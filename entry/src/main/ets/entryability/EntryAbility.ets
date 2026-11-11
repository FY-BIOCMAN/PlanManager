import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { window } from "@kit.ArkUI";
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {}
  onWindowStageCreate(windowStage: window.WindowStage) { windowStage.loadContent("pages/Index", (err, data) => {}); }
}
