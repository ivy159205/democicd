# Sử dụng SDK của .NET 8 để build ứng dụng
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy các file project để restore dependencies trước
COPY WebApplication1.csproj .
RUN dotnet restore

# Copy tất cả các file còn lại và build ứng dụng
COPY . .
RUN dotnet publish -c Release -o out

# Sử dụng runtime của .NET 8 để chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]