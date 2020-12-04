#!/bin/sh

numb='972'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 30 --keyint 300 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.2,2.2,0.5,0.9,0.1,2,0,12,30,300,1,21,0,4,2,62,28,3,2000,-2:-2,dia,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"