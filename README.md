### Look at examples
```
glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 3.0f);
glm::vec3 cameraTarget = glm::vec3(0.0f, 0.0f, 0.0f);
glm::vec3 cameraDirection = glm::normalize(cameraPos - cameraTarget);
glm::vec3 up(0.0f, 1.0f, 0.0f);
glm::vec3 cameraRight = glm::normalize(glm::cross(up, cameraDirection));
glm::vec3 cameraUp = glm::cross(cameraDirection, cameraRight);
glm::vec3 cameraFront(0.0f, 0.0f, -1.0f);
glm::mat4 view;
view = glm::lookAt(cameraPos, cameraPos + cameraFront, cameraUp);

std::cout << "cameraPos " << glm::to_string(cameraPos) << std::endl;
std::cout << "cameraDirection " << glm::to_string(cameraDirection) << std::endl;
std::cout << "up " << glm::to_string(up) << std::endl;
std::cout << "cameraRight " << glm::to_string(cameraRight) << std::endl;
std::cout << "cameraUp " << glm::to_string(cameraUp) << std::endl;
std::cout << "cameraFront " << glm::to_string(cameraFront) << std::endl;
std::cout << "view " << glm::to_string(view) << std::endl;
```