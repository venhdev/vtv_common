# Folder Structure

- src: root folder containing all common file
  - core:
    - base: abstract class (lazy load page, response, usecase)
    - components: ui for all feature (custom btn, widgets, ...)
    - constants: constant value (api, typedef, enum, message)
    - error: custom exception, object return when got error
    - network: handle convert to app object(extends from base)
    - notification: fcm notification
  - features: same feature in other app
    - auth
  - models: contain entity, dto, resp
  - presentation: ui for specific feature
