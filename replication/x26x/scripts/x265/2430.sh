#!/bin/sh

numb='2431'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 15 --keyint 220 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.3,0.8,0.5,0.8,0.7,0,2,0,15,220,1,25,50,5,4,61,18,4,2000,-2:-2,umh,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"