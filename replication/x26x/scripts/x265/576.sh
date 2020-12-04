#!/bin/sh

numb='577'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 45 --keyint 220 --lookahead-threads 4 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.0,1.0,1.8,0.2,0.8,0.0,2,1,8,45,220,4,20,50,3,1,63,48,1,2000,-1:-1,umh,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"