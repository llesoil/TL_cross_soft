#!/bin/sh

numb='927'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.2,2.6,0.4,0.7,0.5,2,0,6,25,300,3,22,50,5,3,61,28,4,1000,-1:-1,dia,show,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"