class MoveDocumentsToFolder < Struct.new(:folder_name, keyword_init: true)
  def call(documents:, folder:, **)
    Folder.find_by! name: folder_name
  end
end
