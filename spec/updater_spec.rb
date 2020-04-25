
describe "Update data from aragon open data" do
  let(:source_file) { "./spec/support/sources/casos_coronavirus_aragon.csv" }
  let(:source) { read_csv(source_file) }
  let(:target_file) { "./spec/support/outputs/coronavirus_cases.csv" }
  let(:expected_target_rows) do
    CSV.read(target_file, headers: true).collect do |row|
      args = row.to_h.transform_keys!(&:to_sym)
      DailyStatisticsOutput.new(args)
    end
  end
  subject(:process_daily_progression) { ProcessToDailyProgression.new }

  it "transform the aragon input file to the output file" do
    target_rows = process_daily_progression.invoke(source, :aragon)
    
    expect(target_rows).to eq expected_target_rows
  end
end