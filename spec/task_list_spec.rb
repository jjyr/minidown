require 'spec_helper'

describe Minidown do
  describe 'task list' do
    it 'should parse correct' do
      str =<<HERE
- [ ] a task list item
- [ ] list syntax required
- [ ] normal **formatting**,
      @mentions, #1234 refs
- [ ] incomplete
- [x] completed
HERE
      Minidown.render(str).should == '<ul class="task-list"><li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" disabled=""> a task list item</li><li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" disabled=""> list syntax required</li><li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" disabled=""><p> normal <strong>formatting</strong>,</p>
<p>@mentions, #1234 refs</p></li><li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" disabled=""> incomplete</li><li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" checked="" disabled=""> completed</li></ul>'
    end
  end
end
