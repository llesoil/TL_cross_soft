#!/bin/sh

numb='3121'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 25 --keyint 280 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.1,0.6,0.3,0.9,0.4,3,0,14,25,280,2,29,20,4,3,64,28,1,2000,-1:-1,dia,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"