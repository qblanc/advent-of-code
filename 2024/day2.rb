require_relative "puzzle_solver"

class Day2 < PuzzleSolver
  def first_result
    safe_reports.count
  end

  def second_result
    safe_reports_with_other_criterias.count
  end

  private

  def safe_reports_with_other_criterias
    safe_reports + partially_safe_reports
  end

  def partially_safe_reports
    @partially_safe_reports ||=
      unsafe_reports.select do |report|
        test_reports = []
        report.size.times do |reference_index|
          test_reports << report.reject.with_index { |number, index| index == reference_index }
        end

        test_reports.any? { |report| check_if_report_is_safe(report) }
      end
  end

  def reports
    @reports ||= @input.map { |report| report.split(" ").map(&:to_i) }
  end

  def unsafe_reports
    @unsafe_reports ||= reports - safe_reports
  end

  def safe_reports
    @safe_reports ||= safe_reports
  end

  def safe_reports
    reports.select { |report| check_if_report_is_safe(report) }
  end

  def check_if_report_is_safe(report)
    return false unless report_is_stricly_ascending_or_descending(report)

    report.each_cons(2).all? do |a, b|
      (a - b).abs > 0 && (a - b).abs <= 3
    end
  end

  def report_is_stricly_ascending_or_descending(report)
    report.sort == report || report.sort.reverse == report
  end

end

Day2.solve


# use each_cons
