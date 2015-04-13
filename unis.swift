
func chunker<T: _ExtensibleCollectionType where T: Sliceable>(chunkSize: T.Index.Distance) -> ([T], T.Generator.Element) -> [T] {
    return { (acc: [T], element: T.Generator.Element) -> [T] in
        if let last = acc.last {
            if count(last) < chunkSize {
                return acc[0..<(count(acc) - 1)] + [last + [element]]
            } else {
                return acc[0..<count(acc)] + [T() + [element]]
            }
        } else {
            return [T() + [element]]
        }
    }
}

func chunk<T: _ExtensibleCollectionType where T: Sliceable>(array: T, chunkSize: T.Index.Distance) -> [T] {
    let combine: (([T], T.Generator.Element) -> [T]) = chunker(chunkSize)
    return reduce(array, [], combine)
}

func convertUnicode(scalars: [UInt32]) -> [Character] {
    return map(scalars, { x in Character(UnicodeScalar(x)) })
}

func main(args: [String]) {

    var scalars: [UInt32] = Array(0xA1...0xA7)
    scalars += [0xA9, 0xAB, 0xAC, 0xAE]
    scalars += [0xB0, 0xB1, 0xB6, 0xBB, 0xBF, 0xD7, 0xF7]
    scalars += [0x2016, 0x2017]
    scalars += 0x2020...0x2027
    scalars += 0x2030...0x203E
    scalars += 0x2041...0x2053
    scalars += 0x2055...0x205E
    scalars += 0x2190...0x23FF
    scalars += 0x2500...0x2775
    scalars += 0x2794...0x2BFF
    scalars += 0x2E00...0x2E00
    scalars += 0x3001...0x3003
    scalars += 0x3008...0x3030
    if args.count > 1 {
        scalars += 0x0300...0x036F
        scalars += 0x1DC0...0x1DFF
        scalars += 0x20D0...0x20FF
        scalars += 0xFE00...0xFE0F
        scalars += 0xFE20...0xFE2F
        scalars += 0xE0100...0xE01EF
    }
    
    let transform = { (x: Character) -> String in String(x) + " " }
    
    let characters = convertUnicode(scalars).map(transform)
    
    let formatter: [String] -> String = { (strings: [String]) -> String in
        let subformatter = { (xs: [String]) -> String in reduce(xs, "", { acc, y in acc + y + " " }) }
        return reduce(chunk(strings, 20), "", { (acc: String, x: [String]) -> String in acc + subformatter(x) + "\n" })
    }
    
    println(formatter(characters))
}

main(Process.arguments)

