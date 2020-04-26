
describe "Update and process data from AragonOpenData" do
  context "Coronavirus statistics for Aragon" do
    let(:source_file) { "./spec/support/sources/casos_coronavirus_aragon.csv" }
    let(:source) { read_csv(source_file) }
    let(:target_file) { "./spec/support/outputs/coronavirus_cases.csv" }
    let(:expected_outputs) do
      CSV.read(target_file, headers: true).collect do |row|
        args = row.to_h.transform_keys!(&:to_sym)
        DailyStatisticsOutput.new(args)
      end
    end
    subject(:process_daily_progression) { ProcessToDailyProgression.new }

    it "transform the input file to the output file" do
      outputs = process_daily_progression.invoke(source, :aragon)
      
      expect(outputs).to eq expected_outputs
    end
  end

  context "Coronavirus hospital ocuppation" do
    subject(:process_hospital_progression) { ProcessHospitalProgression.new }
    let(:source_file) { "./spec/support/sources/casos_coronavirus_hospitales.csv" }
    let(:source) { read_csv(source_file) }
    let(:output) { process_hospital_progression.invoke(source) }
    let(:provinces){ output.provinces }
    let(:municipalities){ provinces.first.municipalities }
    let(:hospitals){ municipalities.first.hospitals }
    it "has provinces" do
      expect(provinces).not_to be_empty
    end
    context "province" do
      it "has name" do
        expect(provinces.first.name).not_to be_nil
      end
      it "has municipalities" do
        expect(municipalities).not_to be_empty
      end
      context "municipality" do
        it "has name" do
          expect(municipalities.first.name).not_to be_nil
        end
        it "has hospitals" do
          expect(hospitals).not_to be_empty
        end
        context "hospital" do
          it "has name" do
            expect(hospitals.first.name).not_to be_nil
          end
          it "has daily_occupations" do
            expect(hospitals.first.daily_occupations).not_to be_empty
          end
        end
      end
    end
  end
end