#!/bin/sh

numb='14'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 40 --keyint 200 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.1,1.2,0.4,0.4,0.9,0.7,2,1,10,40,200,2,25,40,3,1,62,28,3,2000,-1:-1,umh,crop,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"