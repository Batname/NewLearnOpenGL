#ifndef SHADER_H
#define SHADER_H

class Shader
{
public:
    Shader(const char *vertexPath, const char *fragmentPath);

public:
    unsigned int ID;

    void use();

    // utility uniform functions
    void setBool(const char* name, bool value) const;
    void setInt(const char* name, int value) const;
    void setFloat(const char* name, float value) const;
    void setMat4(const char* name, const float *mat4) const;
private:
    enum constants
    {
        LOG_SIZE = 1024
    };

    void checkCompileErrors(unsigned int shader, const char *type);
    char* getFileBuffer(const char* path);
};

#endif