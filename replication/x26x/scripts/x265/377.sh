#!/bin/sh

numb='378'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.3,1.2,0.4,0.3,0.6,0.9,1,1,2,45,240,0,21,0,4,1,68,28,3,2000,1:1,hex,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"