#!/bin/sh

numb='761'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.4,1.2,0.4,0.4,0.8,0.2,3,0,0,10,220,0,26,50,5,4,64,38,6,1000,-1:-1,umh,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"