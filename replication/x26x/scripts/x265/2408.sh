#!/bin/sh

numb='2409'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.2,0.8,0.2,0.8,0.1,0,0,8,10,240,4,30,30,4,2,64,18,2,2000,-1:-1,umh,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"