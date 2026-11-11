import { TaskItem, PriorityColor } from "../../model/TaskModel";
@Entry
@Component
struct WidgetCard {
  @State tasks: TaskItem[] = [
    { id: "p1", parentId: null, title: "鸿蒙开发", startDate: Date.now(), endDate: Date.now(), priority: 3, isCompleted: false },
    { id: "c1", parentId: "p1", title: "UI 调试", startDate: Date.now(), endDate: Date.now(), priority: 1, isCompleted: false }
  ];
  build() {
    Column() {
      Text("我的任务进度").fontSize(16).fontWeight(FontWeight.Bold).fontColor(Color.White).margin({ top: 12, bottom: 8, left: 12 })
      List() { ForEach(this.tasks, (task: TaskItem) => { ListItem() { Row() { Row().width(8).height(8).backgroundColor(PriorityColor[task.priority]).borderRadius(4).margin({ right: 8 }); Text(task.title).fontSize(14).fontColor(Color.White).layoutWeight(1).maxLines(1) }.width("100%").padding({ left: 12, right: 12, top: 8, bottom: 8 }) } }, (task: TaskItem) => task.id) }.width("100%").layoutWeight(1)
    }.width("100%").height("100%").backgroundColor("#1E1E1E")
  }
}
