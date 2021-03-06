#!/bin/sh

numb='642'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 5 --keyint 230 --lookahead-threads 0 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.4,1.4,3.6,0.4,0.8,0.8,1,1,8,5,230,0,21,40,5,1,67,18,3,2000,1:1,hex,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"