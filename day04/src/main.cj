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
            if (chr == LETTERS[0]) {
                if (y + 3 < dim && x + 3 < dim) {
                    if (input[y + 1][x + 1] == XMAS[1] && input[y + 2][x + 2] == XMAS[2] && input[y + 3][x + 3] == XMAS[3]) {
                        println("3. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y + 1][x + 1] = true
                        usedMap[y + 2][x + 2] = true
                        usedMap[y + 3][x + 3] = true
                        count += 1
                    }
                }
            } else if (chr == LETTERS[3]) {
                if (y - 3 >= 0 && x - 3 >= 0) {
                    if (input[y - 1][x - 1] == XMAS[2] && input[y - 2][x - 2] == XMAS[1] && input[y - 3][x - 3] == XMAS[0]) {
                        println("4. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y - 1][x - 1] = true
                        usedMap[y - 2][x - 2] = true
                        usedMap[y - 3][x - 3] = true
                        count += 1
                    }
                }
            }
            // 2. 左下<->右上
            if (chr == LETTERS[0]) {
                if (y - 3 >= 0 && x + 3 < dim) {
                    if (input[y - 1][x + 1] == XMAS[1] && input[y - 2][x + 2] == XMAS[2] && input[y - 3][x + 3] == XMAS[3]) {
                        println("5. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y - 1][x + 1] = true
                        usedMap[y - 2][x + 2] = true
                        usedMap[y - 3][x + 3] = true
                        count += 1
                    }
                }
            } else if (chr == LETTERS[3]) {
                if (y + 3 < dim && x - 3 >= 0) {
                    if (input[y + 1][x - 1] == XMAS[2] && input[y + 2][x - 2] == XMAS[1] && input[y + 3][x - 3] == XMAS[0]) {
                        println("6. Found XMAS at (${y}, ${x})")
                        usedMap[y][x] = true
                        usedMap[y + 1][x - 1] = true
                        usedMap[y + 2][x - 2] = true
                        usedMap[y + 3][x - 3] = true
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

func b(input: Array<String>): Unit {
}

main() {
    let input = readInput()
    let chrs = input.split("\n")
    // let chrs = input.split("\n") |> map {line: String => line.runes() |> collectArray } |> collectArray
    println("[Part A] Number of XMAS and SAMX: ${a(chrs)}")
}
