#!/bin/sh

numb='3114'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 50 --keyint 290 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,--slow-firstpass,--no-weightb,2.0,1.4,1.0,3.0,0.3,0.7,0.1,3,2,14,50,290,4,25,50,5,3,61,18,1,1000,-2:-2,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"