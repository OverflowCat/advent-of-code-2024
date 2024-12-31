package day02

import std.fs.*
import std.collection.*
import std.convert.*
import std.math.*

func isSafe(report: String): Bool {
    var prev: ?Int32 = None
    var increasing: ?Bool = None
    for (part in report.split(' ') |> map { part: String => Int32.parse(part) }) {
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
            println("prev: ${prev}, part: ${part}, diff: ${diff}")
            diff = abs(diff)
            if (diff < 1 || diff > 3) {
                return false
            }
        }
        prev = part
    }
    return true
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

    contentString.split('\n') |> map(isSafe) |> filter { it => it } |> count |> println

    return 0
}
