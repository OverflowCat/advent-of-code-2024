func b(input: Array<String>): Int64 {
    let dim = input.size
    var count = 0

    let usedMap = input |> map {line: String => (line |> map {chr => false} |> collectArray)} |> collectArray

    let runes = input |> map {line: String => line.runes() |> collectArray} |> collectArray

    let A = "A".runes().first().getOrThrow()
    let M = "M".runes().first().getOrThrow()
    let S = "S".runes().first().getOrThrow()

    // 九宫格
    for (y in 0..dim - 2) {
        for (x in 0..dim - 2) {
            let middle = runes[y + 1][x + 1]
            if (middle != A) {
                continue
            }
            let topLeft = runes[y][x]
            let topRight = runes[y][x + 2]
            let btmLeft = runes[y + 2][x]
            let btmRight = runes[y + 2][x + 2]
            if (topLeft == M && btmLeft == M && topRight == S && btmRight == S || // M.S M.S
                topLeft == S && btmLeft == S && topRight == M && btmRight == M || // S.M S.M
                topLeft == S && btmLeft == M && topRight == M && btmRight == S || // S.M M.S
                topLeft == M && btmLeft == S && topRight == S && btmRight == M || // M.S S.M
                topLeft == M && btmLeft == S && topRight == M && btmRight == S || // M.S M.S
                topLeft == S && btmLeft == M && topRight == S && btmRight == M || // S.M S.M
                topLeft == M && btmLeft == M && topRight == S && btmRight == S || // M.M S.S
                topLeft == S && btmLeft == S && topRight == M && btmRight == M) { // S.S M.M
                usedMap[y][x] = true
                usedMap[y][x + 2] = true
                usedMap[y + 2][x] = true
                usedMap[y + 2][x + 2] = true
                usedMap[y + 1][x + 1] = true
                count += 1
            }
        }
    }

    println("Used map:")
    for (y in 0..dim) {
        for (x in 0..dim) {
            print(if (usedMap[y][x]) {
                input[y].runes().at(x).getOrThrow()
            } else {
                "."
            })
        }
        println()
    }
    return count
}
