#!/bin/sh

numb='2302'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 35 --keyint 250 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.0,3.8,0.4,0.9,0.0,1,0,0,35,250,2,23,20,5,2,63,38,2,1000,1:1,umh,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"