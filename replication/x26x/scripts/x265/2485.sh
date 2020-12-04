#!/bin/sh

numb='2486'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 30 --keyint 280 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.0,1.4,3.6,0.2,0.7,0.2,1,1,12,30,280,4,28,0,4,3,62,18,3,1000,1:1,umh,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"