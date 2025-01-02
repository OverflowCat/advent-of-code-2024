package day04

import std.regex.*
import std.fs.*
import std.collection.*
import std.convert.*

func readInput(): String {
    let filePath: Path = Path("./input.txt")

    if (!File.exists(filePath)) {
        throw Exception("Error: The file 'input.txt' does not exist.")
    }

    var file: File = File(filePath, OpenOption.Open(true, false))

    let fileContent: Array<Byte> = file.readToEnd()
    file.close()

    String.fromUtf8(fileContent)
}

func a(input: Array<String>): Int64 {
    let dim = input.size
    var count = 0

    let usedMap = input |> map {line: String => (line |> map {chr => false} |> collectArray)} |> collectArray

    // 找横向的四个字母：XMAS, SAMX
    for (y in 0..dim) {
        let line = input[y].runes() |> collectArray
        let XMAS = "XMAS"
        let LETTERS = XMAS.runes() |> collectArray
        let r = Regex(XMAS).matcher(input[y])
        while (let Some(matchData) <- r.find()) {
            let start = matchData.matchPosition().start
            let end = matchData.matchPosition().end
            for (x in start..end) {
                usedMap[y][x] = true
            }
            count += 1
        }
        let rr = Regex("SAMX").matcher(input[y])
        while (let Some(matchData) <- rr.find()) {
            let start = matchData.matchPosition().start
            let end = matchData.matchPosition().end
            for (x in start..end) {
                usedMap[y][x] = true
            }
            count += 1
        }

        for (x in 0..dim) {
            let chr = line[x]
            // 找竖向的四个字母：XMAS, SAMX
            if (y + 3 < dim) {
                if (input[y][x] == XMAS[0] && input[y + 1][x] == XMAS[1] && input[y + 2][x] == XMAS[2] &&
                    input[y + 3][x] == XMAS[3] ||
                    input[y][x] == XMAS[3] && input[y + 1][x] == XMAS[2] && input[y + 2][x] == XMAS[1] &&
                    input[y + 3][x] == XMAS[0]) {
                    println("1. Found XMAS at (${y}, ${x})")
                    usedMap[y][x] = true
                    usedMap[y + 1][x] = true
                    usedMap[y + 2][x] = true
                    usedMap[y + 3][x] = true
                    count += 1
                }
            }
            // 找斜向的四个字母：XMAS, SAMX
            // 1. 左上<->右下
            if (chr == LETTERS[0]) { // 左上 -> 右下
                if (x < dim - 3 && y < dim - 3) {
                    if (input[y + 1][x + 1] == XMAS[1] && input[y + 2][x + 2] == XMAS[2] && input[y + 3][x + 3] == XMAS[3]) {
                        println("2. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y + 1][x + 1] = true
                        usedMap[y + 2][x + 2] = true
                        usedMap[y + 3][x + 3] = true
                        count += 1
                    }
                }
                if (x > 2 && y > 2) {
                    if (input[y - 1][x - 1] == XMAS[1] && input[y - 2][x - 2] == XMAS[2] && input[y - 3][x - 3] == XMAS[3]) {
                        println("3. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y - 1][x - 1] = true
                        usedMap[y - 2][x - 2] = true
                        usedMap[y - 3][x - 3] = true
                        count += 1
                    }
                }
            }
            // 2. 左下<->右上
            if (chr == LETTERS[0]) { // 右上 -> 左下
                println("x: ${x}, y: ${y}, dim: ${dim}")
                if (x > 2 && y < dim - 3) {
                    if (input[y + 1][x - 1] == XMAS[1] && input[y + 2][x - 2] == XMAS[2] && input[y + 3][x - 3] == XMAS[3]) {
                        println("5. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y + 1][x - 1] = true
                        usedMap[y + 2][x - 2] = true
                        usedMap[y + 3][x - 3] = true
                        count += 1
                    }
                }
                if (x < dim - 3 && y > 2) {
                    if (input[y - 1][x + 1] == XMAS[1] && input[y - 2][x + 2] == XMAS[2] && input[y - 3][x + 3] == XMAS[3]) {
                        println("6. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y - 1][x + 1] = true
                        usedMap[y - 2][x + 2] = true
                        usedMap[y - 3][x + 3] = true
                        count += 1
                    }
                }
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
            /*
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........

M.S   S.M   S.S   M.M
.A.   .A.   .A.   .A.
M.S   S.M   M.M   S.S
            */
            if (topLeft == M && btmLeft == M && topRight == S && btmRight == S || // M.S M.S
                topLeft == S && btmLeft == S && topRight == M && btmRight == M || // S.M S.M
                topLeft == S && btmLeft == M && topRight == S && btmRight == M || // M.M S.S
                topLeft == M && btmLeft == S && topRight == M && btmRight == S) { // S.S M.M
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

main() {
    let input = readInput()
    let chrs = input.split("\n")
    // let chrs = input.split("\n") |> map {line: String => line.runes() |> collectArray } |> collectArray
    // println("[Part A] Number of XMAS and SAMX: ${a(chrs)}")
    println("[Part B] Number of AMS and SMA: ${b(chrs)}")
}
