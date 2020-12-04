#!/bin/sh

numb='1983'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.0,2.2,0.5,0.7,0.3,3,1,2,45,230,0,28,30,5,1,65,18,2,2000,-2:-2,umh,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"