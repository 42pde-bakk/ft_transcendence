class War < ApplicationRecord
  belongs_to :guild1, class_name: "Guild"
  belongs_to :guild2, class_name: "Guild"
end
