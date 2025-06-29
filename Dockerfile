# Sử dụng SDK của .NET 8 để build ứng dụng
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file và restore dependencies
# Đường dẫn: WebApplication1/WebApplication1.csproj từ thư mục cha của Dockerfile
COPY WebApplication1/WebApplication1.csproj ./WebApplication1/WebApplication1.csproj
RUN dotnet restore WebApplication1/WebApplication1/WebApplication1.csproj

# Copy toàn bộ mã nguồn vào thư mục làm việc hiện tại của container
# Context của lệnh "docker build" sẽ là thư mục cha của Dockerfile (democicd/WebApplication1)
# Do đó, "WebApplication1" ở đây sẽ là thư mục chứa mã nguồn
COPY . .

# Xuất bản ứng dụng từ đường dẫn project cụ thể
RUN dotnet publish WebApplication1/WebApplication1/WebApplication1.csproj -c Release -o /app/publish

# Giai đoạn cuối cùng: sử dụng runtime của .NET 8 để chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]