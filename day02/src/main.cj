package day02

import std.fs.*
import std.collection.*
import std.convert.*
import std.math.*

func isSafe(report: Array<Int32>, skip: ?Int64): Bool {
    var prev: ?Int32 = None
    var increasing: ?Bool = None

    for ((i, part) in report |> enumerate) {
        if (let Some(skip) <- skip) {
            if (skip == i) {
                continue
            }
        }

        if (let Some(prev) <- prev) {
            var diff = prev - part
            if (let Some(increasing) <- increasing) {
                let currentTrend = diff > 0
                if (increasing != currentTrend) {
                    return false
                }
            } else {
                increasing = diff > 0
            }
            diff = abs(diff)
            if (diff < 1 || diff > 3) {
                return false
            }
        }
        prev = part
    }
    return true
}

func isTolerantlySafe(report: Array<Int32>): Bool {
    if (isSafe(report, None)) {
        return true
    }
    for (i in 0..report.size) {
        if (isSafe(report, i)) {
            println("Skipping ${i}, ${report}")
            return true
        }
    }
    println("Not safe: ${report}")
    return false
}

main() {
    let filePath: Path = Path("./input.txt")

    if (!File.exists(filePath)) {
        println("Error: The file 'input.txt' does not exist.")
        return 1
    }

    var file: File = File(filePath, OpenOption.Open(true, false))

    let fileContent: Array<Byte> = file.readToEnd()
    file.close()

    let contentString: String = String.fromUtf8(fileContent)

    let reports = contentString.split('\n') |>
        map {
        report => report.split(' ') |> map {part: String => Int32.parse(part)} |> collectArray
    }

    reports |> map(isTolerantlySafe) |>
        // forEach(println)
        filter {it => it} |> count |> println

    return 0
}
