
describe "Update data from aragon open data" do
  let(:source_file) { "./spec/support/sources/casos_coronavirus_aragon.csv" }
  let(:expected_csv) { read_csv("./spec/support/outputs/coronavirus_cases.csv") }
  subject(:process_daily_progression) { ProcessToDailyProgression.new }

  it "transdorm the input file to the output file" do
    source = read_csv(source_file)

    target_rows = process_daily_progression.invoke(source, :aragon)
    write_csv(target_rows, "tmp/coronavirus_cases.csv")
    resultant_csv = read_csv("tmp/coronavirus_cases.csv")
    
    expect(resultant_csv).to eq expected_csv
  end
end