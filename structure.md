# 项目结构概述

本项目的主要游戏逻辑位于 `scripts/` 目录下，采用模块化设计，并通过信号系统进行组件间的通信。

**主要模块功能：**

*   **游戏对象 (game_objects/)**: 定义了游戏中的各种实体，如间谍、敌人、塔以及它们之间的连接线，包含各自的行为和属性。
*   **管理器 (managers/)**: 负责游戏不同方面的管理，例如处理连接逻辑、管理线索数据、控制地图区域状态以及管理间谍的可见性和启用。
*   **状态 (states/)**: 实现了状态机模式，用于管理游戏对象（如间谍和塔）在不同情境下的复杂行为和表现。
*   **数据存储 (stores/)**: 提供全局可访问的静态数据存储，用于保存游戏状态、关卡信息、播放控制和静默状态等。
*   **用户界面 (UI/)**: 包含了游戏用户界面的脚本，负责界面的显示、交互和状态更新，如主界面、进度条和按钮等。
*   **工具集 (utils/)**: 提供各种通用的实用工具函数，例如鼠标位置计算和数组排序等。

**关键机制：**

*   **信号中心**: 作为游戏事件的中央枢纽，负责收集和分发各种游戏事件信号，实现组件间的解耦通信。
*   **状态机**: 用于管理游戏对象在不同状态下的行为逻辑和属性，使得对象行为更加清晰和可控。
*   **连接与路径计算**: 管理游戏对象之间的连接关系，并实现路径查找和可达性判断，是游戏核心玩法的基础。

---

# scripts/ 目录代码结构分析

本文档分析了 `scripts/` 目录下所有 Godot 脚本文件（`.gd`）的主要功能、方法、文件间的引用及耦合程度。

## 目录

*   [核心信号系统](#核心信号系统)
    *   [`scripts/signal_center.gd`](scripts/signal_center.gd): 中央信号发射器和连接器。
    *   [`scripts/signal_manager.gd`](scripts/signal_manager.gd): 信号路由到敌人节点。
*   [game_objects/ 目录](#game_objects-目录)
    *   [game_objects/connection/](#game_objectsconnection)
        *   [`scripts/game_objects/connection/connections.gd`](scripts/game_objects/connection/connections.gd): 管理连接线实例。
    *   [game_objects/enemy/](#game_objectsenemy)
        *   [`scripts/game_objects/enemy/enemy.gd`](scripts/game_objects/enemy/enemy.gd): 敌人角色行为。
    *   [game_objects/spy/](#game_objectsspy)
        *   [`scripts/game_objects/spy/clue_button.gd`](scripts/game_objects/spy/clue_button.gd): 线索按钮数据。
        *   [`scripts/game_objects/spy/enemy_detect_range.gd`](scripts/game_objects/spy/enemy_detect_range.gd): 敌人检测范围。
        *   [`scripts/game_objects/spy/spy_detect_range.gd`](scripts/game_objects/spy/spy_detect_range.gd): 间谍检测范围。
        *   [`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd): 间谍节点鼠标交互。
        *   [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd): 间谍角色核心逻辑。
    *   [game_objects/tower/](#game_objectstower)
        *   [`scripts/game_objects/tower/tower_node.gd`](scripts/game_objects/tower/tower_node.gd): 塔节点鼠标交互。
        *   [`scripts/game_objects/tower/tower.gd`](scripts/game_objects/tower/tower.gd): 塔角色核心逻辑。
*   [managers/ 目录](#managers-目录)
    *   [`scripts/managers/clue_manager.gd`](scripts/managers/clue_manager.gd): 线索数据管理和生成。
    *   [`scripts/managers/connection_manager.gd`](scripts/managers/connection_manager.gd): 连接逻辑管理。
    *   [`scripts/managers/map_sections_manager.gd`](scripts/managers/map_sections_manager.gd): 地图区域管理。
    *   [`scripts/managers/spy_manager.gd`](scripts/managers/spy_manager.gd): 间谍可见性和启用管理。
*   [states/ 目录](#states-目录)
    *   [`scripts/states/state_machine.gd`](scripts/states/state_machine.gd): 通用状态机基类。
    *   [`scripts/states/state.gd`](scripts/states/state.gd): 通用状态基类。
    *   [states/spy/captured/](#statesspycaptured)
        *   [`scripts/states/spy/captured/default.gd`](scripts/states/spy/captured/default.gd): 间谍未捕获状态。
        *   [`scripts/states/spy/captured/locked.gd`](scripts/states/spy/captured/locked.gd): 间谍捕获锁定状态。
        *   [`scripts/states/spy/captured/spy_captured_status_machine.gd`](scripts/states/spy/captured/spy_captured_status_machine.gd): 间谍捕获状态机。
    *   [states/spy/working/](#statesspyworking)
        *   [`scripts/states/spy/working/captured.gd`](scripts/states/spy/working/captured.gd): 间谍工作被捕获状态。
        *   [`scripts/states/spy/working/connecting.gd`](scripts/states/spy/working/connecting.gd): 间谍工作连接状态。
        *   [`scripts/states/spy/working/hovering.gd`](scripts/states/spy/working/hovering.gd): 间谍工作悬停状态。
        *   [`scripts/states/spy/working/idle.gd`](scripts/states/spy/working/idle.gd): 间谍工作空闲状态。
        *   [`scripts/states/spy/working/initializing.gd`](scripts/states/spy/working/initializing.gd): 间谍工作初始化状态。
        *   [`scripts/states/spy/working/invisible.gd`](scripts/states/spy/working/invisible.gd): 间谍工作不可见状态。
        *   [`scripts/states/spy/working/selected.gd`](scripts/states/spy/working/selected.gd): 间谍工作选中状态。
        *   [`scripts/states/spy/working/spy_working_state_machine.gd`](scripts/states/spy/working/spy_working_state_machine.gd): 间谍工作状态机。
        *   [`scripts/states/spy/working/unreachable.gd`](scripts/states/spy/working/unreachable.gd): 间谍工作不可达状态。
    *   [states/tower/](#statestower)
        *   [`scripts/states/tower/tower_working_state_machine.gd`](scripts/states/tower/tower_working_state_machine.gd): 塔工作状态机。
        *   [`scripts/states/tower/towers_manager.gd`](scripts/states/tower/towers_manager.gd): 塔状态和破解进度管理。
*   [stores/ 目录](#stores-目录)
    *   [`scripts/stores/game_store.gd`](scripts/stores/game_store.gd): 游戏全局状态存储。
    *   [`scripts/stores/instances_store.gd`](scripts/stores/instances_store.gd): 游戏实例节点引用存储。
*   [UI/ 目录](#ui-目录)
    *   [`scripts/UI/cracking_progress.gd`](scripts/UI/cracking_progress.gd): 破解进度条显示。
    *   [`scripts/UI/MainUI.gd`](scripts/UI/MainUI.gd): 主 UI 面板管理。
    *   [`scripts/UI/screen_shader.gd`](scripts/UI/screen_shader.gd): 屏幕着色器可见性控制。
    *   [`scripts/UI/silencing_button.gd`](scripts/UI/silencing_button.gd): 静默按钮交互。
    *   [`scripts/UI/silencing_status.gd`](scripts/UI/silencing_status.gd): 静默状态标签更新。
    *   [`scripts/UI/UIManager.gd`](scripts/UI/UIManager.gd): UI 场景总控制器。
*   [utils/ 目录](#utils-目录)
    *   [`scripts/utils/mouse_utils.gd`](scripts/utils/mouse_utils.gd): 鼠标实用工具。
    *   [`scripts/utils/utils.gd`](scripts/utils/utils.gd): 通用实用工具。
*   [耦合度总结](#耦合度总结)
*   [潜在的改进点](#潜在的改进点)

# scripts/ 目录代码结构分析

本文档分析了 `scripts/` 目录下所有 Godot 脚本文件（`.gd`）的主要功能、方法、文件间的引用及耦合程度。

## 核心信号系统

### [`scripts/signal_center.gd`](scripts/signal_center.gd)

*   **主要功能**: 作为游戏事件的中央信号发射器和连接器，负责协调不同游戏组件之间的通信。
*   **主要方法**:
    *   `_ready()`: 初始化时连接各种信号。
    *   `connect_signal(emitter, emitted_signal, callback_fn)`: 通用信号连接方法。
    *   `connect_enemy_patrol_signals(spys, enemies)`: 连接敌人巡逻相关信号。
    *   `_on_spy_instance_radio_range_enemy_entered(signal_spy, signal_enemy)`: 处理间谍进入敌人无线电范围信号。
    *   `_on_spy_instance_radio_range_enemy_exited(signal_spy, signal_enemy)`: 处理间谍离开敌人无线电范围信号。
    *   `_on_enemy_instance_spy_detected(signal_enemy, signal_spy)`: 处理敌人发现间谍信号。
    *   `_on_enemy_instance_spy_captured(signal_enemy, signal_spy)`: 处理敌人捕获间谍信号。
    *   `connect_connection_signals(connection_manager)`: 连接连接管理相关信号。
    *   `_on_connection_manager_new_connection_established(start_spy, end_spy, value)`: 处理新连接建立信号。
    *   `_on_connection_manager_connection_lost(start_spy, end_spy, value)`: 处理连接丢失信号。
    *   `connect_spy_manager_signals(spys)`: 连接间谍管理器相关信号。
    *   `_on_spy_manager_discovered(source_spy, target_spy)`: 处理发现间谍管理器信号。
    *   `_on_spy_manager_lost(source_spy, target_spy)`: 处理间谍管理器丢失信号。
    *   `_on_spy_manager_employed(spy)`: 处理间谍管理器启用信号。
    *   `connect_clue_signals(clue_manager, spys)`: 连接线索相关信号。
    *   `_on_clue_manager_discover_clue(spy_data)`: 处理发现线索信号。
    *   `_on_spy_instance_collect_clue(spy_data)`: 处理收集线索信号。
    *   `connect_map_section_signals()`: 连接地图区域相关信号。
    *   `on_map_sections_manager_map_section_unblocked(map_section)`: 处理地图区域解锁信号。
*   **文件引用/依赖**:
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "Spys" 和 "Enemies"。
    *   通过节点路径 `$"../ConnectionManager"` 引用 `ConnectionManager`。
    *   通过节点路径 `$"../ClueManager"` 引用 `ClueManager`。
    *   通过节点路径 `$"../MapSections"` 引用 `MapSectionsManager`。
    *   连接到来自 Spys (`radio_range_enemy_entered`, `radio_range_enemy_exited`), Enemies (`spy_detected`, `spy_captured`), ConnectionManager (`new_connection_established`, `connection_lost`), MapSectionsManager (`map_section_unblocked`) 的信号。
    *   发射信号供其他节点连接 (`enemy_patrol_entered`, `enemy_patrol_exited`, `enemy_patrol_detected`, `enemy_patrol_captured`, `connection_established`, `connection_changed`, `spy_manager_discovered`, `spy_manager_employed`, `spy_manager_lost`, `clue_discovered`, `clue_collected`, `map_section_unblocked`)。
    *   直接调用 Spy 实例的状态机方法 (`CapturedStateMachine._on_signal_center_enemy_patrol_detected`, `CapturedStateMachine._on_signal_center_enemy_patrol_captured`, `WorkingStateMachine._on_signal_center_enemy_patrol_captured`)。
    *   直接调用 ConnectionManager 方法 (`connection_manager._on_signal_center_connection_changed`)。
    *   直接调用 Spy 实例方法 (`spy._on_signal_center_clue_discovered`, `spy._on_signal_center_clue_collected`)。
*   **耦合程度**: 作为中央信号中心，与多个管理器和游戏对象（Spys, Enemies, ConnectionManager, ClueManager, MapSectionsManager）存在信号连接和直接方法调用，耦合度较高，是系统的核心枢纽。

### [`scripts/signal_manager.gd`](scripts/signal_manager.gd)

*   **主要功能**: 监听 `signal_center` 发出的信号，并将其路由到特定的敌人节点方法。
*   **主要方法**:
    *   `_process(_delta: float)`: 在每一帧检查并连接信号（这里的连接逻辑可能需要优化，不应在 `_process` 中重复连接）。
    *   `connect_signal(emitter, emitted_signal, callback_fn)`: 通用信号连接方法。
*   **文件引用/依赖**:
    *   通过 `@onready var signal_center = $"../SignalCenter"` 引用 `signal_center`。
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "Spys" 和 "Enemies"。
    *   连接到来自 `signal_center` 的信号 (`enemy_patrol_entered`, `enemy_patrol_exited`)。
    *   调用 Enemy 实例的方法 (`enemy.on_enter_radio_range`, `enemy.on_exit_radio_range`)。
*   **耦合程度**: 与 `signal_center` 和 Enemy 节点存在信号连接和方法调用，耦合度适中。其主要作用是将中心信号转发给具体的监听者。

## game_objects/ 目录

### game_objects/connection/

#### [`scripts/game_objects/connection/connections.gd`](scripts/game_objects/connection/connections.gd)

*   **主要功能**: 管理游戏中的连接线实例。
*   **主要方法**:
    *   `_on_signal_center_connection_established(start_node:Variant, end_node:Variant, value:float)`: 处理新连接建立信号，创建并添加 `ConnectionLine` 实例。
*   **文件引用/依赖**:
    *   实例化 `ConnectionLine` 类 (`ConnectionLine.new()`)。
    *   连接到来自 `signal_center` 的信号 (`signal_center_connection_established`)。
    *   将创建的连接线添加到 "Connections" 组。
*   **耦合程度**: 与 `signal_center` 和 `ConnectionLine` 类耦合。通过信号接收连接建立事件，并负责创建连接线的视觉表示。

### game_objects/enemy/

#### [`scripts/game_objects/enemy/enemy.gd`](scripts/game_objects/enemy/enemy.gd)

*   **主要功能**: 定义敌人角色的行为，包括移动、巡逻、发现和捕获间谍、警戒值管理。
*   **主要方法**:
    *   `_process(_delta: float)`: 更新警戒值标签。
    *   `_physics_process(delta: float)`: 处理移动、目标更新、间谍捕获和警戒值变化。
    *   `update_alert_value(new_value: int)`: 更新警戒值并发射信号。
    *   `on_alert_value_changed(previous_value: int, new_value: int)`: 处理警戒值变化逻辑，达到100时尝试发现间谍。
    *   `detect_spy(spy)`: 锁定目标间谍，更新目标位置，发射发现间谍信号。
    *   `is_spy_exposed()`: 判断间谍是否暴露（未静默且在检测列表中）。
    *   `select_new_position()`: 根据间谍暴露状态选择新的移动目标位置。
    *   `choose_random_position()`: 选择一个随机巡逻位置。
    *   `get_nearest_spy()`: 获取检测范围内最近的间谍。
    *   `on_enter_radio_range(spy, enemy)`: 处理进入无线电范围信号，将间谍添加到检测列表。
    *   `on_exit_radio_range(spy, enemy)`: 处理离开无线电范围信号，将间谍从检测列表移除。
*   **文件引用/依赖**:
    *   继承自 `RigidBody2D`。
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "Spys"。
    *   通过节点路径 `$Label` 引用子节点 Label。
    *   引用全局存储 `GameStore.SilencingStore` 判断静默状态。
    *   引用工具类 `Utils` 进行数组排序。
    *   发射信号 (`spy_detected`, `spy_captured`, `alert_value_changed`)。
    *   被 `signal_manager.gd` 连接其 `on_enter_radio_range` 和 `on_exit_radio_range` 方法。
*   **耦合程度**: 与 Spys 节点组、Label 子节点、`GameStore`、`Utils` 耦合。通过信号与外部通信，但直接引用 `GameStore` 和 `Utils` 增加了耦合度。

### game_objects/spy/

#### [`scripts/game_objects/spy/clue_button.gd`](scripts/game_objects/spy/clue_button.gd)

*   **主要功能**: 管理线索按钮的状态和数据。
*   **主要方法**: 无特殊方法，主要作为数据载体 (`spy_data`)。
*   **文件引用/依赖**: 继承自 `Button`。
*   **耦合程度**: 低，主要被 [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd) 引用和控制。

#### [`scripts/game_objects/spy/enemy_detect_range.gd`](scripts/game_objects/spy/enemy_detect_range.gd)

*   **主要功能**: 定义敌人检测范围的视觉和碰撞区域。
*   **主要方法**:
    *   `_process(_delta)`: 更新碰撞形状半径并重绘。
    *   `_draw()`: 绘制检测范围的圆形。
*   **文件引用/依赖**:
    *   继承自 `Area2D`。
    *   通过节点路径 `get_node("RangeCollision").shape` 引用碰撞形状。
*   **耦合程度**: 低，主要被其父节点（可能是 Spy）引用和控制。

#### [`scripts/game_objects/spy/spy_detect_range.gd`](scripts/game_objects/spy/spy_detect_range.gd)

*   **主要功能**: 定义间谍检测范围的视觉和碰撞区域。
*   **主要方法**:
    *   `_process(_delta)`: 更新碰撞形状半径并重绘。
    *   `_draw()`: 绘制检测范围的圆形。
*   **文件引用/依赖**:
    *   继承自 `Area2D`。
    *   通过节点路径 `get_node("RangeCollision").shape` 引用碰撞形状。
*   **耦合程度**: 低，主要被其父节点（可能是 Spy）引用和控制。

#### [`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd)

*   **主要功能**: 处理间谍节点的鼠标交互（悬停、选中）。
*   **主要方法**:
    *   `_ready()`: 连接 `mouse_still_inside` 信号。
    *   `_process(_delta)`: 检查鼠标位置，发射 `mouse_still_inside` 信号。
    *   `hover_handler()`: 处理悬停逻辑，根据鼠标状态切换间谍工作状态机状态。
    *   `_on_mouse_still_inside()`: 处理鼠标持续在节点内信号。
    *   `_on_mouse_entered()`: 处理鼠标进入节点信号。
    *   `_on_mouse_exited()`: 处理鼠标离开节点信号。
*   **文件引用/依赖**:
    *   继承自 `Area2D`。
    *   通过节点路径 `get_node('../WorkingStateMachine')` 引用父节点的 `WorkingStateMachine`。
    *   发射信号 (`mouse_still_inside`)。
    *   调用工作状态机方法 (`node_switch_to`, `node_switch_to_last_stable_state`, `get_state_name`, `is_state`, `last_stable_state_name`)。
*   **耦合程度**: 与父节点的 `WorkingStateMachine` 紧密耦合，直接调用其方法进行状态切换。

#### [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd)

*   **主要功能**: 定义间谍角色的属性、状态和行为，包括连接建立、敌人检测、线索发现和收集。
*   **主要方法**:
    *   `_ready()`: 初始化线索按钮可见性。
    *   `_process(_delta: float)`: 处理连接建立过程中的鼠标输入和预览线绘制。
    *   `_on_enemy_detect_range_body_entered(body: Node2D)`: 处理进入敌人检测范围信号。
    *   `_on_enemy_detect_range_body_exited(body: Node2D)`: 处理离开敌人检测范围信号。
    *   `_on_spy_detect_range_area_entered(area: Area2D)`: 处理进入间谍检测范围信号。
    *   `_on_spy_detect_range_area_exited(_area: Area2D)`: 处理离开间谍检测范围信号（当前为空）。
    *   `discover_clue(data)`: 显示线索按钮并设置数据。
    *   `_on_clue_button_pressed()`: 处理线索按钮按下信号，发射收集线索信号。
    *   `_on_signal_center_clue_discovered(data)`: 处理线索被发现信号，更新自身状态。
    *   `_on_signal_center_clue_collected(data)`: 处理线索被收集信号，更新自身状态。
    *   `ConnectionUtils` 类: 包含处理连接预览线的静态工具方法。
*   **文件引用/依赖**:
    *   继承自 `Node2D`，类名为 `SpyInstance`。
    *   通过 `@onready var` 引用子节点 `ConnectionLines`, `EnemyDetectRange`, `WorkingStateMachine`, `CapturedStateMachine`, `ClueButton`。
    *   实例化 `ConnectionLine` 类 (`ConnectionLine.new()`)。
    *   引用静态工具类 `ConnectionUtils`。
    *   发射信号 (`building_connection_started`, `building_connection_ended`, `radio_range_enemy_entered`, `radio_range_enemy_exited`, `connect_range_spy_entered`, `connect_range_spy_exited`, `collect_clue`)。
    *   连接到来自 `signal_center` 的信号 (`signal_center_clue_discovered`, `signal_center_clue_collected`)。
    *   连接到来自子节点 `EnemyDetectRange` (`body_entered`, `body_exited`), `SpyDetectRange` (`area_entered`, `area_exited`), `ClueButton` (`pressed`) 的信号。
*   **耦合程度**: 与多个子节点、状态机、`ConnectionLine` 类、`ConnectionUtils` 类、`signal_center` 耦合。是间谍角色的核心脚本，集成了多种功能和交互逻辑。

### game_objects/tower/

#### [`scripts/game_objects/tower/tower_node.gd`](scripts/game_objects/tower/tower_node.gd)

*   **主要功能**: 处理塔节点的鼠标交互（悬停、选中）。与 [`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd) 功能类似。
*   **主要方法**:
    *   `_ready()`: 连接 `mouse_still_inside` 信号。
    *   `_process(_delta)`: 检查鼠标位置，发射 `mouse_still_inside` 信号。
    *   `hover_handler()`: 处理悬停逻辑，根据鼠标状态切换塔工作状态机状态。
    *   `_on_mouse_still_inside()`: 处理鼠标持续在节点内信号。
    *   `_on_mouse_entered()`: 处理鼠标进入节点信号。
    *   `_on_mouse_exited()`: 处理鼠标离开节点信号。
*   **文件引用/依赖**:
    *   继承自 `Area2D`。
    *   通过节点路径 `get_node('../WorkingStateMachine')` 引用父节点的 `WorkingStateMachine`。
    *   发射信号 (`mouse_still_inside`)。
    *   调用工作状态机方法 (`node_switch_to`, `node_switch_to_last_stable_state`, `get_state_name`, `is_state`, `last_stable_state_name`)。
*   **耦合程度**: 与父节点的 `WorkingStateMachine` 紧密耦合，直接调用其方法进行状态切换。与 [`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd) 结构和功能高度相似。

#### [`scripts/game_objects/tower/tower.gd`](scripts/game_objects/tower/tower.gd)

*   **主要功能**: 定义塔角色的属性、状态和行为，包括连接建立和破解进度管理。
*   **主要方法**:
    *   `_init()`: 初始化。
    *   `_process(_delta: float)`: 处理连接建立过程中的鼠标输入和预览线绘制，更新破解进度。
    *   `ConnectionUtils` 类: 包含处理连接预览线的静态工具方法（与 [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd) 中的类重复）。
    *   `update_cracking_progress()`: 更新破解进度。
*   **文件引用/依赖**:
    *   继承自 `Node2D`，类名为 `TowerInstance`。
    *   通过 `@onready var` 引用子节点 `ConnectionLines`, `WorkingStateMachine`。
    *   实例化 `ConnectionLine` 类 (`ConnectionLine.new()`)。
    *   引用静态工具类 `ConnectionUtils`。
    *   发射信号 (`building_connection_started`, `building_connection_ended`)。
*   **耦合程度**: 与子节点、状态机、`ConnectionLine` 类、`ConnectionUtils` 类耦合。是塔角色的核心脚本。与 [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd) 在连接建立逻辑上有相似之处。

## managers/ 目录

### [`scripts/managers/clue_manager.gd`](scripts/managers/clue_manager.gd)

*   **主要功能**: 管理线索数据，从 JSON 文件加载线索信息，并处理线索的发现和生成。
*   **主要方法**:
    *   `_ready()`: 读取 `spy_data.json` 文件，解析 JSON，初始化间谍数据。
    *   `get_all_spys_data(select_all = true, select_discovered = false, select_collected = false)`: 获取符合条件的间谍数据列表。
    *   `get_not_discovered_spys_data()`: 获取未发现的间谍数据。
    *   `get_collected_spys_data()`: 获取已收集的间谍数据。
    *   `generate_random_clue()`: 随机生成一个未发现的线索，并通知间谍显示线索按钮。
    *   `select_random_spy_data(target_spy_data: Array)`: 从给定数组中随机选择一个间谍数据。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `FileAccess.open()` 读取 `res://data/spy_data.json` 文件。
    *   使用 `JSON.parse_string()` 解析 JSON 数据。
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "Spys"。
    *   发射信号 (`discover_clue`)。
    *   调用 Spy 实例方法 (`spy.spy_data = spy_data`, `spy.is_undercover = true`, `spy.discover_clue(new_discovered_spy_data)`)。
*   **耦合程度**: 与 `spy_data.json` 文件、Spys 节点组耦合。负责数据加载和线索生成分发。

### [`scripts/managers/connection_manager.gd`](scripts/managers/connection_manager.gd)

*   **主要功能**: 管理游戏中的连接，包括添加/移除连接、查找路径、判断可达性、处理连接建立和丢失事件。
*   **主要方法**:
    *   `update_nodes()`: 更新所有可连接节点（塔和间谍）列表。
    *   `add_connection(start_spy, end_spy, value = 1)`: 添加新的连接。
    *   `remove_connection_from_spy(spy)`: 移除与指定间谍相关的所有连接。
    *   `get_all_connections_from_spy(spy)`: 获取与指定间谍相关的所有连接对。
    *   `match_connection_nodes(connection, start_spy, end_spy)`: 检查连接实例是否匹配给定的节点对。
    *   `has_connection(start_spy, end_spy)`: 检查两个节点之间是否存在连接。
    *   `get_connection_instance(start_spy, end_spy)`: 获取两个节点之间的连接线实例。
    *   `get_connection_value(start_spy, end_spy)`: 获取两个节点之间的连接值。
    *   `get_reachable_nodes(start_spy, visited_nodes = [], reachable_nodes = [])`: 使用深度优先搜索获取从起始节点可达的所有节点。
    *   `get_shortest_paths_from_node(start_spy)`: 使用 Dijkstra 算法计算从起始节点到所有其他节点的最短路径。
    *   `get_shortest_path_to_node(start_spy, end_spy)`: 获取从起始节点到目标节点的最短路径上的连接线实例列表。
    *   `is_connect_to_node(source_spy, target_spy)`: 判断两个节点是否连接（可达）。
    *   `is_inside_path_to_tower(source_spy)`: 判断间谍是否在通往塔的路径上（且不在通往主间谍的路径上）。
    *   `update_reachable_status()`: 更新所有节点的可达性状态。
    *   `connect_connection_signals(spy_instances: Array)`: 连接间谍实例的连接建立/结束信号。
    *   `_ready()`: 初始化时更新节点列表并连接信号。
    *   `_on_spy_node_building_connection_ended(end_node)`: 处理间谍节点连接结束信号，尝试添加新连接。
    *   `_on_spy_node_building_connection_started(start_node)`: 处理间谍节点连接开始信号。
    *   `emit_signal_and_clear_connecting_nodes()`: 发射新连接建立信号并清除临时连接节点。
    *   `_on_signal_center_enemy_patrol_captured(spy: Variant, _enemy: Variant)`: 处理间谍被捕获信号，移除相关连接。
    *   `_on_signal_center_connection_changed(_start_spy: Node, _end_spy: Node, _value: Variant)`: 处理连接改变信号，更新间谍是否在通往塔的路径上状态。
*   **文件引用/依赖**:
    *   继承自 `Node`，类名为 `ConnectionManager`。
    *   通过 `@export var` 引用 `master_spy`, `tower`, `test_spy` (类型为 `SpyInstance` 或 `TowerInstance`)。
    *   通过 `@onready var connections_instance = $"../Connections"` 引用 `connections_instance` 节点（类型可能是 [`scripts/game_objects/connection/connections.gd`](scripts/game_objects/connection/connections.gd)）。
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "Towers" 和 "Spys"。
    *   引用 `TowerInstance` 和 `SpyInstance` 类进行类型检查。
    *   发射信号 (`new_connection_established`, `connection_lost`)。
    *   连接到来自 Spy 实例 (`building_connection_started`, `building_connection_ended`) 和 `signal_center` (`signal_center_enemy_patrol_captured`, `signal_center_connection_changed`) 的信号。
    *   调用 Spy 实例方法 (`spy.connections = {}`, `spy.working_state_machine.node_switch_to("Unreachable")`, `node.is_inside_path_to_tower = is_inside_path_to_tower(node)`).
    *   调用 Connection 实例方法 (`connection.queue_free()`).
*   **耦合程度**: 与 `SpyInstance`, `TowerInstance` 类、"Towers" 和 "Spys" 节点组、`connections_instance` 节点、`signal_center` 紧密耦合。是连接系统的核心，负责连接的逻辑管理和状态更新。

### [`scripts/managers/map_sections_manager.gd`](scripts/managers/map_sections_manager.gd)

*   **主要功能**: 管理地图区域，检测间谍所在的区域，并在区域解锁时更新间谍数据。
*   **主要方法**:
    *   `_ready()`: 初始化时发射 `map_section_unblocked` 信号。
    *   `_physics_process(delta: float)`: 在物理帧更新间谍所在的地图区域数据（TODO 标记需要优化）。
    *   `update_spy_section_data()`: 更新所有间谍所在的地图区域信息。
    *   `is_spy_in_section(spy, map_section)`: 判断间谍是否在指定的地图区域内。
    *   `_on_signal_center_map_section_unblocked(_section:Variant)`: 处理地图区域解锁信号，更新间谍区域数据。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `@export var` 引用 `spawn_section` 和 `master_spy` (类型为 `Area2D` 和 `Node2D`)。
    *   通过 `get_tree().get_nodes_in_group()` 引用节点组 "MapSections" 和 "Spys"。
    *   发射信号 (`map_section_unblocked`)。
    *   连接到来自 `signal_center` 的信号 (`signal_center_map_section_unblocked`)。
    *   调用 Spy 实例方法 (`spy.node_status.in_section = section`, `spy.get_node("SpyBody")`).
    *   调用 Area2D 方法 (`map_section.overlaps_area(target_area)`).
*   **耦合程度**: 与 "MapSections" 和 "Spys" 节点组、`signal_center` 耦合。负责地图区域与间谍位置的关联。

### [`scripts/managers/spy_manager.gd`](scripts/managers/spy_manager.gd)

*   **主要功能**: 管理间谍的可见性和启用状态。
*   **主要方法**:
    *   `_ready()`: 初始化时将所有间谍设置为不可见状态，主间谍设置为初始化状态。
    *   `_process(_delta: float)`: 根据开发标志控制间谍可见性。
    *   `_on_signal_center_spy_manager_discovered(_source_spy, target_spy)`: 处理发现间谍管理器信号，显示间谍。
    *   `show_spy(spy)`: 显示间谍，并根据其状态切换工作状态机。
    *   `_on_signal_center_connection_established(start_node: Variant, end_node: Variant, _value)`: 处理连接建立信号，更新可达性并启用间谍。
    *   `employ_spy(spy)`: 启用间谍，并根据其状态切换工作状态机。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `@onready var` 引用节点组 "Spys" 和 `ConnectionManager`。
    *   发射信号 (`employ_new_spy`)。
    *   连接到来自 `signal_center` (`signal_center_spy_manager_discovered`, `signal_center_connection_established`) 的信号。
    *   调用 Spy 实例方法 (`spy.get_node("WorkingStateMachine")`, `working_state_machine.node_switch_to(...)`, `spy.is_in_group(...)`, `spy.add_to_group(...)`, `spy.remove_from_group(...)`, `spy.node_status["is_employed"] = true`, `spy.connections`).
    *   调用 ConnectionManager 方法 (`connection_manager.update_reachable_status()`).
*   **耦合程度**: 与 "Spys" 节点组、`ConnectionManager`、`signal_center`、Spy 实例的状态机紧密耦合。负责间谍的生命周期和状态管理。

## states/ 目录

### [`scripts/states/state_machine.gd`](scripts/states/state_machine.gd)

*   **主要功能**: 通用的状态机基类，管理状态的切换和生命周期方法调用。
*   **主要方法**:
    *   `_ready()`: 初始化状态机，查找子节点中的状态并进入初始状态。
    *   `switch_to(state_name, data: Dictionary = {})`: 切换到指定状态，调用当前状态的 `exit` 和新状态的 `enter` 方法。
    *   `switch_to_when_not(new_state_name, condition_state_name, data: Dictionary = {})`: 在当前状态不是指定状态时切换状态。
    *   `get_state_by_name(state_name: String)`: 根据名称获取状态节点。
    *   `get_state()`: 获取当前状态节点。
    *   `get_state_name()`: 获取当前状态名称。
    *   `is_state(state_name: String)`: 检查当前是否为指定状态。
*   **文件引用/依赖**:
    *   类名为 `StateMachine`，继承自 `Node`。
    *   引用 `State` 类。
    *   发射信号 (`state_changed`)。
*   **耦合程度**: 作为基类，与 `State` 类耦合。被各种具体的 StateMachine 类继承。

### [`scripts/states/state.gd`](scripts/states/state.gd)

*   **主要功能**: 通用的状态基类，定义状态的生命周期方法。
*   **主要方法**:
    *   `get_state_machine()`: 获取父节点（状态机）。
    *   `get_current_state()`: 获取当前状态机中的当前状态。
    *   `enter(_data)`: 进入状态时调用。
    *   `exit()`: 退出状态时调用。
    *   `state_process(_delta)`: 在状态机处理函数中调用（如果状态机调用了）。
    *   `switch_to(state_name, data: Dictionary = {})`: 调用父状态机的状态切换方法。
*   **文件引用/依赖**:
    *   类名为 `State`，继承自 `Node`。
    *   引用 `StateMachine` 类。
*   **耦合程度**: 作为基类，与 `StateMachine` 类耦合。被各种具体的状态类继承。

### states/spy/captured/

#### [`scripts/states/spy/captured/default.gd`](scripts/states/spy/captured/default.gd)

*   **主要功能**: 间谍被捕获状态机的默认状态，表示未被捕获。
*   **主要方法**:
    *   `enter(_data)`: 进入状态时调用父状态机的 `mark_as_not_captured` 方法。
*   **文件引用/依赖**: 继承自 `State`。调用父状态机方法。
*   **耦合程度**: 与父状态机紧密耦合。

#### [`scripts/states/spy/captured/locked.gd`](scripts/states/spy/captured/locked.gd)

*   **主要功能**: 间谍被捕获状态机的锁定状态，表示已被捕获。
*   **主要方法**:
    *   `enter(_data)`: 进入状态时调用父状态机的 `mark_as_captured` 方法。
*   **文件引用/依赖**: 继承自 `State`。调用父状态机方法。
*   **耦合程度**: 与父状态机紧密耦合。

#### [`scripts/states/spy/captured/spy_captured_status_machine.gd`](scripts/states/spy/captured/spy_captured_status_machine.gd)

*   **主要功能**: 间谍被捕获状态机的具体实现，管理间谍的捕获标记和分组。
*   **主要方法**:
    *   `mark_as_captured()`: 显示捕获标记，将间谍添加到 "LockedSpys" 组。
    *   `mark_as_not_captured()`: 隐藏捕获标记，将间谍从 "LockedSpys" 组移除。
    *   `_on_signal_center_enemy_patrol_detected(spy, _enemy)`: 处理敌人发现间谍信号，切换到 "Locked" 状态。
    *   `_on_signal_center_enemy_patrol_captured(spy, _enemy)`: 处理敌人捕获间谍信号，切换到 "Default" 状态。
*   **文件引用/依赖**:
    *   类名为 `SpyCapturedStateMachine`，继承自 `StateMachine`。
    *   通过 `@onready var` 引用父节点（间谍实例）和子节点 `CapturedMark`。
    *   连接到来自 `signal_center` 的信号 (`signal_center_enemy_patrol_detected`, `signal_center_enemy_patrol_captured`)。
    *   调用间谍实例方法 (`spy_instance.add_to_group`, `spy_instance.remove_from_group`).
*   **耦合程度**: 与父节点（间谍实例）、子节点 `CapturedMark`、`signal_center` 紧密耦合。

### states/spy/working/

#### [`scripts/states/spy/working/captured.gd`](scripts/states/spy/working/captured.gd)

*   **主要功能**: 间谍工作状态机的被捕获状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/connecting.gd`](scripts/states/spy/working/connecting.gd)

*   **主要功能**: 间谍工作状态机的连接状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/hovering.gd`](scripts/states/spy/working/hovering.gd)

*   **主要功能**: 间谍工作状态机的悬停状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/idle.gd`](scripts/states/spy/working/idle.gd)

*   **主要功能**: 间谍工作状态机的空闲状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/initializing.gd`](scripts/states/spy/working/initializing.gd)

*   **主要功能**: 间谍工作状态机的初始化状态，用于间谍刚出现时的过渡。
*   **主要方法**:
    *   `_init()`: 初始化定时器。
    *   `enter(_data)`: 进入状态时启动定时器。
    *   `_process(_delta: float)`: 更新标签显示初始化进度。
    *   `_on_timer_timeout()`: 定时器超时时切换到 "Idle" 状态。
    *   `exit()`: 退出状态时标记已初始化并设置间谍为已启用。
*   **文件引用/依赖**:
    *   继承自 `State`。
    *   通过 `@onready var` 引用父节点的 Label 和间谍实例。
    *   实例化 `Timer` 类。
    *   连接到 Timer 的 `timeout` 信号。
    *   调用父状态机方法 (`node_switch_to`)。
    *   调用间谍实例方法 (`spy.node_status["is_employed"] = true`).
*   **耦合程度**: 与父节点的 Label 和间谍实例、Timer 紧密耦合。

#### [`scripts/states/spy/working/invisible.gd`](scripts/states/spy/working/invisible.gd)

*   **主要功能**: 间谍工作状态机的不可见状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/selected.gd`](scripts/states/spy/working/selected.gd)

*   **主要功能**: 间谍工作状态机的选中状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

#### [`scripts/states/spy/working/spy_working_state_machine.gd`](scripts/states/spy/working/spy_working_state_machine.gd)

*   **主要功能**: 间谍工作状态机的具体实现，管理间谍的视觉表现和检测范围启用状态。
*   **主要方法**:
    *   `node_switch_to(state_name: String, data: Dictionary = {})`: 切换状态，并根据新状态的属性更新间谍节点的视觉和检测范围状态。
    *   `set_status(state_status, key)`: 获取状态属性值，处理 "keep" 关键字。
    *   `node_switch_to_last_stable_state(data: Dictionary = {})`: 切换回上一个稳定状态。
    *   `_on_signal_center_enemy_patrol_captured(spy, _enemy)`: 处理敌人捕获间谍信号，切换到 "Captured" 状态。
*   **文件引用/依赖**:
    *   类名为 `SpyWorkingStateMachine`，继承自 `StateMachine`。
    *   通过 `@onready var` 引用父节点（间谍实例）和子节点 `SpyNode`, `Label`, `SpyDetectRange`, `EnemyDetectRange`。
    *   连接到来自 `signal_center` 的信号 (`signal_center_enemy_patrol_captured`)。
    *   调用子节点方法 (`spy_node.scale = ...`, `label.text = ...`, `spy_node.set_pickable(...)`, `spy_instance.visible = ...`, `spy_detect_range.monitoring = ...`, `enemy_detect_range.monitoring = ...`).
    *   引用各种具体的间谍工作状态类（通过 `get_state_by_name` 获取状态对象）。
*   **耦合程度**: 与父节点（间谍实例）、多个子节点、`signal_center`、以及各种具体的间谍工作状态类紧密耦合。

#### [`scripts/states/spy/working/unreachable.gd`](scripts/states/spy/working/unreachable.gd)

*   **主要功能**: 间谍工作状态机的不可达状态，定义间谍在该状态下的视觉和交互属性。
*   **主要方法**: 无特殊方法，主要通过 `spy_state_status` 字典定义状态属性。
*   **文件引用/依赖**: 继承自 `State`。
*   **耦合程度**: 低，主要被父状态机引用其 `spy_state_status` 字典。

### states/tower/

#### [`scripts/states/tower/tower_working_state_machine.gd`](scripts/states/tower/tower_working_state_machine.gd)

*   **主要功能**: 塔工作状态机的具体实现，管理塔的视觉表现和交互状态。与 [`scripts/states/spy/working/spy_working_state_machine.gd`](scripts/states/spy/working/spy_working_state_machine.gd) 功能类似。
*   **主要方法**:
    *   `node_switch_to(state_name: String, data: Dictionary = {})`: 切换状态，并根据新状态的属性更新塔节点的视觉和交互状态。
    *   `set_status(state_status, key)`: 获取状态属性值，处理 "keep" 关键字。
    *   `node_switch_to_last_stable_state(data: Dictionary = {})`: 切换回上一个稳定状态。
*   **文件引用/依赖**:
    *   类名为 `TowerWorkingStateMachine`，继承自 `StateMachine`。
    *   通过 `@onready var` 引用父节点（塔实例）和子节点 `TowerNode`, `Label`。
    *   调用子节点方法 (`tower_node.scale = ...`, `label.text = ...`, `tower_node.set_pickable(...)`, `tower_instance.visible = ...`).
    *   引用各种具体的塔工作状态类（通过 `get_state_by_name` 获取状态对象）。
*   **耦合程度**: 与父节点（塔实例）、多个子节点、以及各种具体的塔工作状态类紧密耦合。与 [`scripts/states/spy/working/spy_working_state_machine.gd`](scripts/states/spy/working/spy_working_state_machine.gd) 结构和功能高度相似。

#### [`scripts/states/tower/towers_manager.gd`](scripts/states/tower/towers_manager.gd)

*   **主要功能**: 管理塔的状态和破解进度条的显示。
*   **主要方法**:
    *   `_ready()`: 初始化塔数量，将所有塔设置为不可见状态。
    *   `_process(_delta: float)`: 更新总破解进度比例，并设置破解进度条的大小。
    *   `_on_signal_center_spy_manager_discovered(_source_spy, target_spy)`: 处理发现间谍管理器信号，显示间谍（此方法可能不属于塔管理器，或者逻辑有误，因为它调用了 `show_spy` 方法，但参数是 spy，且内部逻辑处理的是 InvisibleSpys）。
    *   `show_spy(spy)`: 显示间谍，并根据其状态切换工作状态机（此方法与 `spy_manager.gd` 中的 `show_spy` 方法重复且逻辑相似）。
    *   `_on_signal_center_connection_established(start_node: Variant, end_node: Variant, _value)`: 处理连接建立信号，更新可达性并启用塔。
    *   `employ_spy(tower)`: 启用塔，并根据其状态切换工作状态机（方法名应为 `employ_tower` 更合适）。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `@onready var` 引用节点组 "Towers"、`ConnectionManager` 和 UI 节点 `CrackingProgress/ProgressBar`。
    *   引用全局存储 `GameStore.LevelStore`。
    *   连接到来自 `signal_center` (`signal_center_spy_manager_discovered`, `signal_center_connection_established`) 的信号。
    *   调用 Tower 实例方法 (`tower.get_node("WorkingStateMachine")`, `working_state_machine.node_switch_to(...)`, `tower.is_in_group(...)`, `tower.add_to_group(...)`, `tower.remove_from_group(...)`, `tower.cracking_progress`, `tower.node_status["reachable"]`).
    *   调用 ConnectionManager 方法 (`connection_manager.update_reachable_status()`).
    *   调用 ProgressBar 方法 (`cracking_progress_bar.set_custom_minimum_size(...)`).
*   **耦合程度**: 与 "Towers" 节点组、`ConnectionManager`、UI 节点、`GameStore`、`signal_center`、Tower 实例的状态机紧密耦合。负责塔的整体管理和与 UI 的交互。存在与 `spy_manager.gd` 重复的逻辑。

## stores/ 目录

### [`scripts/stores/game_store.gd`](scripts/stores/game_store.gd)

*   **主要功能**: 静态类，用于存储游戏全局状态和数据。
*   **主要方法**:
    *   `LevelStore` 类: 存储关卡相关数据 (`tower_count`)。
    *   `PlayStore` 类: 存储游戏播放状态和速度 (`is_playing`, `playing_speed`, `get_playing_speed`, `set_playing_speed`, `pause`, `resume`)。
    *   `SilencingStore` 类: 存储静默状态 (`is_silencing`, `get_silence_state`, `set_silence`)。
    *   `ConnectingStore` 类: 存储连接过程中的临时节点 (`is_connecting`, `start_node`, `end_node`)。
*   **文件引用/依赖**: 继承自 `Node`。包含多个静态内部类。
*   **耦合程度**: 低，作为全局可访问的数据存储，被多个其他脚本引用。

### [`scripts/stores/instances_store.gd`](scripts/stores/instances_store.gd)

*   **主要功能**: 存储游戏中的各种实例节点的引用。
*   **主要方法**:
    *   `_ready()`: 初始化时获取并存储各种节点组的引用。
    *   `get_spys()`: 获取 "Spys" 组节点。
    *   `get_visible_spys()`: 获取 "VisibleSpys" 组节点。
    *   `get_invisible_spys()`: 获取 "InvisibleSpys" 组节点。
    *   `get_map_sections()`: 获取 "MapSections" 组节点。
*   **文件引用/依赖**:
    *   类名为 `GameObjects`，继承自 `Node`。
    *   通过 `get_tree().get_nodes_in_group()` 获取节点组引用。
*   **耦合程度**: 低，主要用于集中管理节点实例的引用。

## UI/ 目录

### [`scripts/UI/cracking_progress.gd`](scripts/UI/cracking_progress.gd)

*   **主要功能**: 控制破解进度条的显示。
*   **主要方法**:
    *   `_ready()`: 初始化时获取敌人节点，连接其 `alert_value_changed` 信号，设置进度条最大值。
    *   `_on_alert_value_changed(previous_value: int, new_value: int)`: 处理敌人警戒值变化信号，更新进度条的值。
*   **文件引用/依赖**:
    *   继承自 `ProgressBar`。
    *   通过 `get_tree().get_first_node_in_group("Enemies")` 获取敌人节点。
    *   连接到 Enemy 实例的 `alert_value_changed` 信号。
*   **耦合程度**: 与 Enemy 节点紧密耦合，直接监听其信号。

### [`scripts/UI/MainUI.gd`](scripts/UI/MainUI.gd)

*   **主要功能**: 管理主用户界面面板的显示和切换。
*   **主要方法**:
    *   `_ready()`: 初始化时获取所有面板子节点，连接按钮信号。
    *   `switch_to_panel(panel_name: String)`: 隐藏所有面板并显示指定面板。
    *   `_on_button_pressed(panel_name: String)`: 示例方法，根据按钮名称切换面板。
    *   `_on_menu_button_pressed()`: 处理菜单按钮按下信号，显示 MenuUI。
    *   `_on_aa_button_pressed()`: 处理 AA 按钮按下信号，显示 AAUI。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `@onready var` 引用子节点 `menu_button`, `aa_button`。
    *   通过 `get_children()` 查找 Panel 子节点。
    *   通过 `get_parent().get_node(...)` 引用同级节点 MenuUI 和 AAUI。
    *   连接到按钮的 `pressed` 信号。
*   **耦合程度**: 与子节点按钮、同级 UI 节点（MenuUI, AAUI）耦合。负责 UI 导航逻辑。

### [`scripts/UI/screen_shader.gd`](scripts/UI/screen_shader.gd)

*   **主要功能**: 根据静默状态控制屏幕着色器的可见性。
*   **主要方法**:
    *   `_process(_delta: float)`: 在每一帧检查静默状态并更新可见性。
*   **文件引用/依赖**:
    *   继承自 `ColorRect`。
    *   引用全局存储 `GameStore.SilencingStore` 获取静默状态。
*   **耦合程度**: 与 `GameStore.SilencingStore` 耦合。

### [`scripts/UI/silencing_button.gd`](scripts/UI/silencing_button.gd)

*   **主要功能**: 控制静默按钮的交互和静默状态的切换。
*   **主要方法**:
    *   `_ready()`: 连接按钮按下/释放信号。
    *   `_process(_delta: float)`: 根据按钮状态或输入动作设置静默状态。
    *   `on_pressed()`: 处理按钮按下事件。
    *   `on_released()`: 处理按钮释放事件。
*   **文件引用/依赖**:
    *   继承自 `TextureButton`。
    *   引用全局存储 `GameStore.SilencingStore` 设置静默状态。
*   **耦合程度**: 与 `GameStore.SilencingStore` 耦合。

### [`scripts/UI/silencing_status.gd`](scripts/UI/silencing_status.gd)

*   **主要功能**: 根据静默状态更新静默状态标签的文本。
*   **主要方法**:
    *   `_process(_delta: float)`: 在每一帧检查静默状态并更新标签文本。
*   **文件引用/依赖**:
    *   继承自 `Label`。
    *   引用全局存储 `GameStore.SilencingStore` 获取静默状态。
*   **耦合程度**: 与 `GameStore.SilencingStore` 耦合。

### [`scripts/UI/UIManager.gd`](scripts/UI/UIManager.gd)

*   **主要功能**: 管理游戏中的所有用户界面，控制不同 UI 场景的显示和切换。
*   **主要方法**:
    *   `_ready()`: 初始化时获取所有 UI 子节点，设置初始可见性，连接主 UI 按钮信号。
    *   `switch_to_panel(panel_name: String)`: 隐藏所有面板并显示指定面板（此方法与 `MainUI.gd` 中的方法重复）。
    *   `_on_button_pressed(panel_name: String)`: 示例方法，根据按钮名称切换面板（此方法与 `MainUI.gd` 中的方法重复）。
    *   `show_ui(ui: Node)`: 显示指定的 UI 节点。
    *   `hide_ui(ui: Node)`: 隐藏指定的 UI 节点。
    *   `_on_menu_button_pressed()`: 处理菜单按钮按下信号，切换到 MenuUI。
    *   `_on_aa_button_pressed()`: 处理 AA 按钮按下信号，切换到 AAUI。
*   **文件引用/依赖**:
    *   继承自 `Node`。
    *   通过 `@onready var` 引用子节点 `main_ui`, `menu_ui`, `aa_ui`。
    *   通过 `get_children()` 查找 Panel 子节点。
    *   通过 `main_ui.get_node(...)` 引用 MainUI 的子节点按钮。
    *   连接到 MainUI 子节点按钮的 `pressed` 信号。
*   **耦合程度**: 与其子节点 UI 场景（MainUI, MenuUI, AAUI）紧密耦合。是 UI 系统的总控制器。存在与 `MainUI.gd` 重复的逻辑。

## utils/ 目录

### [`scripts/utils/mouse_utils.gd`](scripts/utils/mouse_utils.gd)

*   **主要功能**: 提供鼠标相关的实用工具函数。
*   **主要方法**:
    *   `get_local_mouse_position(current_node)`: 获取鼠标在指定节点局部坐标系中的位置。
    *   `is_mouse_in_range(current_node, radius)`: 判断鼠标是否在指定节点的指定半径范围内。
*   **文件引用/依赖**: 类名为 `MouseUtils`。静态方法。
*   **耦合程度**: 低，作为工具类被其他需要鼠标位置或范围判断的脚本引用。

### [`scripts/utils/utils.gd`](scripts/utils/utils.gd)

*   **主要功能**: 提供通用的实用工具函数，如数组排序。
*   **主要方法**:
    *   `reversed(original_array)`: 返回数组的倒序副本。
    *   `sorted(original_array)`: 返回数组的排序副本。
    *   `sorted_custom(original_array, sort_func)`: 使用自定义函数对数组进行排序并返回副本。
*   **文件引用/依赖**: 类名为 `Utils`，继承自 `Node`。静态方法。
*   **耦合程度**: 低，作为工具类被其他需要数组操作的脚本引用。

## 耦合度总结

*   **高耦合**:
    *   [`scripts/signal_center.gd`](scripts/signal_center.gd): 作为中央信号枢纽，与多个管理器和游戏对象紧密相连。
    *   [`scripts/managers/connection_manager.gd`](scripts/managers/connection_manager.gd): 管理连接逻辑，与间谍、塔、信号中心、连接实例等紧密交互。
    *   [`scripts/states/spy/working/spy_working_state_machine.gd`](scripts/states/spy/working/spy_working_state_machine.gd) / [`scripts/states/tower/tower_working_state_machine.gd`](scripts/states/tower/tower_working_state_machine.gd): 与其宿主节点（间谍/塔）及其子节点、以及具体的状态类紧密耦合。
    *   [`scripts/managers/spy_manager.gd`](scripts/managers/spy_manager.gd) / [`scripts/states/tower/towers_manager.gd`](scripts/states/tower/towers_manager.gd): 管理间谍/塔的整体状态，与节点组、连接管理器、信号中心、状态机等紧密耦合。
    *   [`scripts/UI/UIManager.gd`](scripts/UI/UIManager.gd): UI 系统的总控制器，与各个 UI 场景紧密耦合。
*   **中耦合**:
    *   [`scripts/signal_manager.gd`](scripts/signal_manager.gd): 将中心信号路由到敌人节点。
    *   [`scripts/game_objects/enemy/enemy.gd`](scripts/game_objects/enemy/enemy.gd): 与 Spys 节点组、GameStore、Utils 耦合，通过信号与外部通信。
    *   [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd) / [`scripts/game_objects/tower/tower.gd`](scripts/game_objects/tower/tower.gd): 游戏对象的核心脚本，与子节点、状态机、连接相关类、信号中心耦合。
    *   [`scripts/managers/clue_manager.gd`](scripts/managers/clue_manager.gd): 与数据文件、Spys 节点组耦合。
    *   [`scripts/managers/map_sections_manager.gd`](scripts/managers/map_sections_manager.gd): 与地图区域、Spys 节点组、信号中心耦合。
    *   [`scripts/UI/cracking_progress.gd`](scripts/UI/cracking_progress.gd): 与 Enemy 节点耦合。
    *   [`scripts/UI/MainUI.gd`](scripts/UI/MainUI.gd): 与子节点按钮、同级 UI 节点耦合。
*   **低耦合**:
    *   [`scripts/game_objects/connection/connections.gd`](scripts/game_objects/connection/connections.gd): 主要响应信号创建连接线。
    *   [`scripts/game_objects/spy/clue_button.gd`](scripts/game_objects/spy/clue_button.gd): 数据载体。
    *   [`scripts/game_objects/spy/enemy_detect_range.gd`](scripts/game_objects/spy/enemy_detect_range.gd) / [`scripts/game_objects/spy/spy_detect_range.gd`](scripts/game_objects/spy/spy_detect_range.gd): 主要定义范围。
    *   [`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd) / [`scripts/game_objects/tower/tower_node.gd`](scripts/game_objects/tower/tower_node.gd): 处理鼠标交互，与父状态机紧密耦合，但与其他系统耦合度较低。
    *   [`scripts/states/state_machine.gd`](scripts/states/state_machine.gd) / [`scripts/states/state.gd`](scripts/states/state.gd): 状态机/状态基类。
    *   具体的 State 类 (e.g., `default.gd`, `locked.gd`, `captured.gd`, `connecting.gd`, `hovering.gd`, `idle.gd`, `initializing.gd`, `invisible.gd`, `selected.gd`, `unreachable.gd`): 主要定义状态属性或简单的进入/退出逻辑。
    *   [`scripts/stores/game_store.gd`](scripts/stores/game_store.gd) / [`scripts/stores/instances_store.gd`](scripts/stores/instances_store.gd): 全局数据/实例存储。
    *   [`scripts/UI/screen_shader.gd`](scripts/UI/screen_shader.gd) / [`scripts/UI/silencing_button.gd`](scripts/UI/silencing_button.gd) / [`scripts/UI/silencing_status.gd`](scripts/UI/silencing_status.gd): 主要与 GameStore 耦合。
    *   [`scripts/utils/mouse_utils.gd`](scripts/utils/mouse_utils.gd) / [`scripts/utils/utils.gd`](scripts/utils/utils.gd): 通用工具类。

## 潜在的改进点

*   **重复代码**: [`scripts/game_objects/spy/spy.gd`](scripts/game_objects/spy/spy.gd) 和 [`scripts/game_objects/tower/tower.gd`](scripts/game_objects/tower/tower.gd) 中的 `ConnectionUtils` 类定义重复。[`scripts/game_objects/spy/spy_node.gd`](scripts/game_objects/spy/spy_node.gd) 和 [`scripts/game_objects/tower/tower_node.gd`](scripts/game_objects/tower/tower_node.gd) 功能高度相似。[`scripts/managers/spy_manager.gd`](scripts/managers/spy_manager.gd) 和 [`scripts/states/tower/towers_manager.gd`](scripts/states/tower/towers_manager.gd) 中的 `show_spy` 方法重复。[`scripts/UI/MainUI.gd`](scripts/UI/MainUI.gd) 和 [`scripts/UI/UIManager.gd`](scripts/UI/UIManager.gd) 中的面板切换逻辑重复。可以将这些重复或相似的功能提取到基类或通用的工具脚本中。
*   **`_process` 中的信号连接**: [`scripts/signal_manager.gd`](scripts/signal_manager.gd) 在 `_process` 中连接信号，这会导致每一帧都尝试连接，效率低下且可能引入问题。信号连接通常只需要在初始化时进行。
*   **`_physics_process` 中的数据更新**: [`scripts/managers/map_sections_manager.gd`](scripts/managers/map_sections_manager.gd) 在 `_physics_process` 中更新间谍区域数据，并有 TODO 标记，可能需要优化更新频率或方式。
*   **命名一致性**: [`scripts/states/tower/towers_manager.gd`](scripts/states/tower/towers_manager.gd) 中的 `employ_spy` 方法实际上是启用塔，方法名应更准确。
*   **全局存储引用**: 虽然全局存储 (`GameStore`) 方便访问，但过度使用会增加耦合度。可以考虑通过信号或依赖注入来降低直接引用。
