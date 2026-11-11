import { DatabaseManager } from "../common/DatabaseManager";
import { TaskItem, PriorityColor } from "../model/TaskModel";
import { common } from "@kit.AbilityKit";
@Entry
@Component
struct Index {
  @State tasks: TaskItem[] = [];
  @State currentMonthDays: number = 30;
  @State isLoading: boolean = true;
  async aboutToAppear() {
    await DatabaseManager.init(getContext(this) as common.UIAbilityContext);
    this.loadData();
  }
  async loadData() {
    this.isLoading = true;
    const allTasks = await DatabaseManager.getAllTasks();
    const roots = allTasks.filter(t => !t.parentId);
    const result: TaskItem[] = [];
    roots.forEach(root => { result.push(root); allTasks.filter(t => t.parentId === root.id).forEach(child => result.push(child)); });
    this.tasks = result; this.isLoading = false;
  }
  @Builder TaskRow(task: TaskItem) {
    Row() {
      Text(task.title).fontSize(task.parentId ? 14 : 16).fontWeight(task.parentId ? FontWeight.Normal : FontWeight.Bold).width("30%").margin({ left: task.parentId ? 16 : 0 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
      Stack({ alignContent: Alignment.Start }) {
        Row().width("100%").height("100%").border({ width: { right: 1 }, color: "#333333" })
        Row().width(`${((task.endDate - task.startDate) / (24 * 60 * 60 * 1000)) / this.currentMonthDays * 100}%`).height(20).backgroundColor(task.isCompleted ? "#555555" : PriorityColor[task.priority]).borderRadius(4).margin({ left: `${(new Date(task.startDate).getDate() / this.currentMonthDays) * 100}%` })
      }.layoutWeight(1).height(30)
    }.width("100%").height(40).border({ width: { bottom: 1 }, color: "#222222" })
  }
  build() {
    Column() {
      Row() { Text("本月目标 (11月)").fontSize(20).fontWeight(FontWeight.Bold).fontColor(Color.White) }.width("100%").padding(16).backgroundColor("#1E1E1E")
      if (this.isLoading) { LoadingProgress().width(50).height(50).margin({ top: 50 }) } else {
        Scroll() {
          Column() {
            Row() { Text("1日").fontSize(10).fontColor(Color.Gray); Blank(); Text("15日").fontSize(10).fontColor(Color.Gray); Blank(); Text("30日").fontSize(10).fontColor(Color.Gray) }.width("70%").margin({ left: "30%", bottom: 10 })
            ForEach(this.tasks, (task: TaskItem) => { this.TaskRow(task) }, (task: TaskItem) => task.id)
          }.width("100%")
        }.layoutWeight(1)
      }
    }.width("100%").height("100%").backgroundColor("#121212")
  }
}
