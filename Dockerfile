# Sử dụng SDK của .NET 8 để build ứng dụng
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file để restore dependencies trước
# Đường dẫn tương đối từ thư mục gốc của context build (democicd/) đến project file
COPY WebApplication1/WebApplication1/WebApplication1.csproj ./WebApplication1/WebApplication1/WebApplication1.csproj
RUN dotnet restore WebApplication1/WebApplication1/WebApplication1.csproj

# Copy toàn bộ mã nguồn từ thư mục gốc của context build (democicd/) vào /src
COPY . .

# Xuất bản ứng dụng từ đường dẫn project cụ thể
RUN dotnet publish WebApplication1/WebApplication1/WebApplication1.csproj -c Release -o /app/publish

# Giai đoạn cuối cùng: sử dụng runtime của .NET 8 để chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]