#include "Shader.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <glad/glad.h>

Shader::Shader(const char *vertexPath, const char *fragmentPath)
{
    unsigned int vertex, fragment;

    // Compile vertex shader
    char *vertexBuffer = getFileBuffer(vertexPath);
    vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &vertexBuffer, NULL);
    glCompileShader(vertex);
    checkCompileErrors(vertex, "VERTEX");
    free(vertexBuffer);

    // Compile fragment shader
    char *fragmentBuffer = getFileBuffer(fragmentPath);
    fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &fragmentBuffer, NULL);
    glCompileShader(fragment);
    checkCompileErrors(fragment, "FRAGMENT");
    free(fragmentBuffer);

    // Shader program
    ID = glCreateProgram();
    glAttachShader(ID, vertex);
    glAttachShader(ID, fragment);
    glLinkProgram(ID);
    checkCompileErrors(ID, "PROGRAM");

    // delete shaders
    glDeleteShader(vertex);
    glDeleteShader(fragment);
}

void Shader::use()
{
    glUseProgram(ID);
}

char* Shader::getFileBuffer(const char* path)
{
    FILE *vertexFile;
    vertexFile = fopen(path, "rb");
    int length;
    char *buffer = NULL;
    size_t result;

    if (vertexFile == NULL)
    {
        printf("[ERROR] can not open file from path %s\n", path);
        exit(-1);
    }

    // File size
    fseek(vertexFile, 0, SEEK_END);
    length = ftell(vertexFile);
    rewind(vertexFile); // Set position of stream to the beginning

    // allocate memory to contain the whole file:
    buffer = (char*) malloc(sizeof(char) * length + 1);
    if (buffer == NULL)
    {
        printf("[ERROR] can not allocate buffer\n");
        exit(-1);
    }

    // Copy into buffer
    result = fread(buffer, sizeof(char), length, vertexFile);
    if (result != length)
    {
        printf("[ERROR] reading error\n");
        exit(-1);
    }
    buffer[length] = '\0';
    fclose(vertexFile);

    return buffer;
}

void Shader::checkCompileErrors(unsigned int shader, const char *type)
{
    int success;
    char infoLog[LOG_SIZE];

    if (strcmp(type, "PROGRAM") != 0)
    {
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success)
        {
            glGetShaderInfoLog(shader, LOG_SIZE, NULL, infoLog);
            printf("ERROR::SHADER_COMPILATION_ERROR of type: %s \n %s\n", type, infoLog);
            exit(-1);
        }
    }
    else
    {
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        glGetProgramInfoLog(shader, LOG_SIZE, NULL, infoLog);
        if (!success)
        {
            glGetProgramInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR::PROGRAM_LINKING_ERROR of type: %s \n %s\n", type, infoLog);
            exit(-1);
        }
    }
}

void Shader::setBool(const char* name, bool value) const
{
    glUniform1i(glGetUniformLocation(ID, name), (int)value);
}

void Shader::setInt(const char* name, int value) const
{
    glUniform1i(glGetUniformLocation(ID, name), value);
}

void Shader::setFloat(const char* name, float value) const
{
    glUniform1f(glGetUniformLocation(ID, name), value);
}