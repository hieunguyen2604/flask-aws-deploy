#!/bin/bash

REGION="us-east-1"

echo "🔍 Đang kiểm tra EC2 instances..."
EC2_IDS=$(aws ec2 describe-instances --region $REGION --query 'Reservations[].Instances[?State.Name==`running`].InstanceId' --output text)

if [ -n "$EC2_IDS" ]; then
  echo "🗑️ Terminating EC2 instances: $EC2_IDS"
  aws ec2 terminate-instances --region $REGION --instance-ids $EC2_IDS
else
  echo "✅ Không có EC2 nào đang chạy"
fi

echo "🔍 Kiểm tra Elastic IP chưa gán..."
UNUSED_EIP_ALLOCS=$(aws ec2 describe-addresses --region $REGION --query 'Addresses[?AssociationId==null].AllocationId' --output text)

if [ -n "$UNUSED_EIP_ALLOCS" ]; then
  echo "🗑️ Releasing unused Elastic IPs..."
  for alloc_id in $UNUSED_EIP_ALLOCS; do
    aws ec2 release-address --region $REGION --allocation-id $alloc_id
  done
else
  echo "✅ Không có Elastic IP dư thừa"
fi

echo "🔍 Kiểm tra Key Pairs..."
KEYS=$(aws ec2 describe-key-pairs --region $REGION --query 'KeyPairs[].KeyName' --output text)
for key in $KEYS; do
  echo "🗑️ Xoá Key Pair: $key"
  aws ec2 delete-key-pair --region $REGION --key-name $key
done

echo "🔍 Kiểm tra Security Groups không mặc định..."
SGS=$(aws ec2 describe-security-groups --region $REGION --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
for sg in $SGS; do
  echo "🗑️ Xoá Security Group: $sg"
  aws ec2 delete-security-group --region $REGION --group-id $sg 2>/dev/null || echo "❗ SG $sg đang được dùng"
done

echo "🎉 Cleanup hoàn tất!"
