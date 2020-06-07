library fat_framework;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

part 'src/vibration_service.dart';
part 'src/application.dart';
part 'src/audio_player.dart';
part 'src/chat/chat_message.dart';
part 'src/chat/extra_toolbar.dart';
part 'src/chat/single_chat.dart';
part 'src/chat/single_chat_controller.dart';
part 'src/chat/toolbar.dart';
part 'src/constants.dart';
part 'src/data/app_version.dart';
part 'src/device_manager.dart';
part 'src/form.dart';
part 'src/form_model.dart';
part 'src/formatter.dart';
part 'src/http_service.dart';
part 'src/initialize.dart';
part 'src/keyboard.dart';
part 'src/keyboards/keyboard_container.dart';
part 'src/keyboards/keyboard_controller.dart';
part 'src/keyboards/keyboard_events.dart';
part 'src/keyboards/keyboard_manager.dart';
part 'src/keyboards/money_keyboard.dart';
part 'src/loading_service.dart';
part 'src/output_service.dart';
part 'src/preference_manager.dart';
part 'src/provider.dart';
part 'src/provider_screen.dart';
part 'src/router.dart';
part 'src/screen.dart';
part 'src/service.dart';
part 'src/service_locator.dart';
part 'src/stateful_screen.dart';
part 'src/stateless_screen.dart';
part 'src/toast_manager.dart';
part 'src/types.dart';
part 'src/ui/badge.dart';
part 'src/ui/ball.dart';
part 'src/ui/button.dart';
part 'src/ui/cells.dart';
part 'src/ui/circle_button.dart';
part 'src/ui/clickable_field.dart';
part 'src/ui/flat_icon.dart';
part 'src/ui/form_model_field_cell.dart';
part 'src/ui/grid_icon_button.dart';
part 'src/ui/input_field.dart';
part 'src/ui/list_sheet.dart';
part 'src/ui/readonly_field.dart';
part 'src/ui/space.dart';
part 'src/ui/tag.dart';
part 'src/ui/textarea_field.dart';
part 'src/ui/uploader.dart';
part 'src/upgrade_service.dart';
part 'src/utils/url_util.dart';
part 'src/websocket/websocket_manager.dart';
part 'src/websocket/websocket_types.dart';
