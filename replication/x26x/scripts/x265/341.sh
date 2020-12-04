#!/bin/sh

numb='342'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.0,0.4,0.4,0.9,0.7,0,2,12,50,300,1,25,20,4,4,61,28,3,1000,1:1,hex,show,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"