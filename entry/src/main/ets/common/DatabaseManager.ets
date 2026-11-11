import { relationalStore } from "@kit.ArkData";
import { common } from "@kit.AbilityKit";
import { TaskItem } from "../model/TaskModel";
const STORE_CONFIG: relationalStore.StoreConfig = { name: "TimeManager.db", securityLevel: relationalStore.SecurityLevel.S1 };
const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS task (id TEXT PRIMARY KEY, parentId TEXT, title TEXT NOT NULL, startDate INTEGER NOT NULL, endDate INTEGER NOT NULL, priority INTEGER DEFAULT 1, isCompleted INTEGER DEFAULT 0)`;
export class DatabaseManager {
  private static store: relationalStore.RdbStore | null = null;
  static async init(context: common.Context) {
    if (this.store) return;
    this.store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    await this.store.executeSql(SQL_CREATE_TABLE);
    await this.insertMockData();
  }
  private static async insertMockData() {
    if (!this.store) return;
    const resultSet = await this.store.query(new relationalStore.RdbPredicates("task"), ["id"]);
    if (resultSet.rowCount > 0) { resultSet.close(); return; }
    resultSet.close();
    const now = Date.now(); const day = 24 * 60 * 60 * 1000;
    await this.store.insert("task", { id: "p1", parentId: null, title: "鸿蒙时间管理开发", startDate: now - day*2, endDate: now + day*5, priority: 3, isCompleted: false });
    await this.store.insert("task", { id: "c1", parentId: "p1", title: "数据库设计", startDate: now - day*2, endDate: now, priority: 2, isCompleted: true });
    await this.store.insert("task", { id: "c2", parentId: "p1", title: "甘特图UI开发", startDate: now, endDate: now + day*3, priority: 1, isCompleted: false });
  }
  static async getAllTasks(): Promise<TaskItem[]> {
    if (!this.store) return [];
    const resultSet = await this.store.query(new relationalStore.RdbPredicates("task"));
    const tasks: TaskItem[] = [];
    while (resultSet.goToNextRow()) {
      tasks.push({ id: resultSet.getString(resultSet.getColumnIndex("id")), parentId: resultSet.getString(resultSet.getColumnIndex("parentId")), title: resultSet.getString(resultSet.getColumnIndex("title")), startDate: resultSet.getLong(resultSet.getColumnIndex("startDate")), endDate: resultSet.getLong(resultSet.getColumnIndex("endDate")), priority: resultSet.getLong(resultSet.getColumnIndex("priority")), isCompleted: resultSet.getLong(resultSet.getColumnIndex("isCompleted")) === 1 });
    }
    resultSet.close(); return tasks;
  }
}
