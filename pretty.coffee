# write_pretty_story, a writing program for writers
# who don't want to edit what they write.

filterText = (text) ->
  filteredText = text.replace('--', '&mdash;')

  # split on empty line (markdown style)
  paragraphs = filteredText.split(/\n\n\n*/)
  return paragraphs

formatNewParagraph = (text) ->
  paragraphs = filterText(text)
  for paragraph in paragraphs
    newParagraph = $(document.createElement('p'))
    newParagraph.html(paragraph)
    $('#written-text').append(newParagraph)

makeNewParagraph = () ->
  textarea = $('#writebox textarea')
  text = textarea.val()
  formatNewParagraph(text)
  textarea.val('')

onkeypress = (event) ->
  if event.which is 13
    $('#write-form').submit()

onSubmit = (event) ->
  event.preventDefault()
  makeNewParagraph()

mainText =
  textArea: () ->
    $('#writebox textarea')
  appStuff: () ->
    $('h1.story-title,#bd')
  show: () ->
    @appStuff().show()
    @textArea().focus()
  hide: () ->
    @appStuff().hide()

titleTextBox = () ->
  $('#title-edit input[name="title"]')

showTitleRequest = () ->
  $('#title-edit').addClass('requesting')
  titleTextBox().focus()

hideTitleRequest = () ->
  $('#title-edit').removeClass('requesting')

getTitle = () ->
  titleInput = titleTextBox()
  title = titleInput.val()
  $('h1.story-title').html(title)
  hideTitleRequest()
  mainText.show()

requestTitle = () ->
  mainText.hide()
  showTitleRequest()

onReady = () ->
  $('#write-form').submit(onSubmit)
  $('#writebox textarea').keypress(onkeypress)
  requestTitle()
  titleTextBox().keypress(() ->
    if event.which is 13
      getTitle()
  )

$(document).ready(onReady)
