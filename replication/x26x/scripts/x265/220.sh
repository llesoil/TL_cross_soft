#!/bin/sh

numb='221'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 45 --keyint 250 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.3,1.1,3.0,0.2,0.7,0.6,3,2,4,45,250,3,23,20,3,1,60,18,4,1000,1:1,umh,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"