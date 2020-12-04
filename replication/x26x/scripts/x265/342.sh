#!/bin/sh

numb='343'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 50 --keyint 260 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.1,4.8,0.5,0.9,0.9,1,0,4,50,260,4,22,50,3,3,65,48,3,1000,-1:-1,umh,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"