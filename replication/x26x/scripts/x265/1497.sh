#!/bin/sh

numb='1498'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 40 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.3,1.1,0.8,0.4,0.7,0.5,3,0,2,40,260,2,29,40,5,3,61,48,5,1000,1:1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"