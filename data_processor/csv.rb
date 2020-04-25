
require "csv"

def read_csv(path)
  CSV.read(path, headers: true, col_sep: ";", liberal_parsing: true)
end

def write_csv(target_rows, path)
  headers = target_rows.first.to_h.keys
  CSV.open(path, "w", write_headers: true, headers: headers) do |targert_csv|
    target_rows.each do |target_row|
      targert_csv << target_row.to_h
    end
  end
end