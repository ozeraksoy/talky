/**
 * CSInterface - Adobe CEP Panel <-> Host Communication
 * Kaynak: https://github.com/Adobe-CEP/CEP-Resources (MIT License)
 * Bu dosya Adobe'nin açık kaynak CEP kütüphanesinin temel implementasyonudur.
 */

'use strict';

var SystemPath = {
  USER_DATA:      'userData',
  COMMON_FILES:   'commonFiles',
  MY_DOCUMENTS:   'myDocuments',
  APPLICATION:    'application',
  EXTENSION:      'extension',
  HOST_APPLICATION: 'hostApplication'
};

var ColorType = { CUSTOM: 'custom', FOREGROUND: 'foreground', BACKGROUND: 'background' };

var CSEvent = function(type, scope, appId, extensionId) {
  this.type        = type;
  this.scope       = scope   || 'APPLICATION';
  this.appId       = appId   || 'UNKNOWN';
  this.extensionId = extensionId || '';
  this.data        = '';
};

var UpdateType = { MAJOR: 'MAJOR', MINOR: 'MINOR', PATCH: 'PATCH' };

var CSInterface = function() {
  this.hostEnvironment = this.getHostEnvironment();
};

CSInterface.THEME_COLOR_CHANGED_EVENT   = 'com.adobe.csxs.events.ThemeColorChanged';
CSInterface.EXTENSION_LOADED_EVENT      = 'com.adobe.csxs.events.ApplicationLoaded';

/**
 * CEP native interface'e erişim
 */
CSInterface.prototype._cep = function() {
  return window.__adobe_cep__;
};

/**
 * Host ortamı bilgisi
 */
CSInterface.prototype.getHostEnvironment = function() {
  var cep = this._cep();
  if (cep) {
    try {
      return JSON.parse(cep.getHostEnvironment());
    } catch (e) {}
  }
  return { appId: 'PPRO', appVersion: '0.0', appLocale: 'en_US' };
};

/**
 * ExtendScript çalıştır
 * @param {string} script  - JSX kodu
 * @param {function} callback - function(result)
 */
CSInterface.prototype.evalScript = function(script, callback) {
  var cep = this._cep();
  if (!cep) {
    if (typeof callback === 'function') callback('EvalScript error.');
    return;
  }
  if (typeof callback !== 'function') {
    callback = function() {};
  }
  cep.evalScript(script, callback);
};

/**
 * Sistem yolu al
 */
CSInterface.prototype.getSystemPath = function(pathType) {
  var cep = this._cep();
  if (!cep) return '';
  try {
    var path = cep.getSystemPath(pathType);
    return path || '';
  } catch (e) {
    return '';
  }
};

/**
 * Extension klasörünün yolunu al
 */
CSInterface.prototype.getExtensionPath = function() {
  return this.getSystemPath(SystemPath.EXTENSION);
};

/**
 * Event listener ekle
 */
CSInterface.prototype.addEventListener = function(type, listener, obj) {
  var cep = this._cep();
  if (!cep) return;
  try {
    cep.addEventListener(type, listener, obj || null);
  } catch (e) {}
};

/**
 * Event listener kaldır
 */
CSInterface.prototype.removeEventListener = function(type, listener, obj) {
  var cep = this._cep();
  if (!cep) return;
  try {
    cep.removeEventListener(type, listener, obj || null);
  } catch (e) {}
};

/**
 * Event gönder
 */
CSInterface.prototype.dispatchEvent = function(event) {
  var cep = this._cep();
  if (!cep) return;
  try {
    if (typeof event.data === 'object') {
      event.data = JSON.stringify(event.data);
    }
    cep.dispatchEvent(event);
  } catch (e) {}
};

/**
 * URL'yi varsayılan tarayıcıda aç
 */
CSInterface.prototype.openURLInDefaultBrowser = function(url) {
  var cep = this._cep();
  if (!cep) return false;
  try {
    cep.openURLInDefaultBrowser(url);
    return true;
  } catch (e) {
    return false;
  }
};

/**
 * CEP sürümünü al
 */
CSInterface.prototype.getCurrentApiVersion = function() {
  var cep = this._cep();
  if (!cep) return { major: 10, minor: 0, micro: 0 };
  try {
    return JSON.parse(cep.getCurrentApiVersion());
  } catch (e) {
    return { major: 10, minor: 0, micro: 0 };
  }
};

/**
 * Uygulama sürümünü al
 */
CSInterface.prototype.getApplicationVersion = function() {
  var env = this.getHostEnvironment();
  return env ? (env.appVersion || '0.0') : '0.0';
};

/**
 * Uygulama ID'sini al
 */
CSInterface.prototype.getApplicationID = function() {
  var env = this.getHostEnvironment();
  return env ? (env.appId || 'PPRO') : 'PPRO';
};

/**
 * Extension'ı kapat
 */
CSInterface.prototype.closeExtension = function() {
  var cep = this._cep();
  if (!cep) return;
  try { cep.closeExtension(); } catch (e) {}
};

/**
 * Panel görünürlüğünü ayarla
 */
CSInterface.prototype.requestOpenExtension = function(extensionId, params) {
  var cep = this._cep();
  if (!cep) return;
  try { cep.requestOpenExtension(extensionId, params || ''); } catch (e) {}
};

/**
 * Tema bilgisi al (AppSkinInfo)
 */
CSInterface.prototype.getHostEnvironment = function() {
  var cep = this._cep();
  if (!cep) return {};
  try {
    return JSON.parse(cep.getHostEnvironment());
  } catch (e) {
    return {};
  }
};
