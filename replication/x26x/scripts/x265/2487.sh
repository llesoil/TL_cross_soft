#!/bin/sh

numb='2488'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 10 --keyint 240 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.5,1.3,4.2,0.3,0.7,0.1,1,2,10,10,240,2,29,30,5,1,64,28,6,2000,-2:-2,umh,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"