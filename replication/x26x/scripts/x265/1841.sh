#!/bin/sh

numb='1842'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 10 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.1,1.0,2.4,0.4,0.7,0.7,2,2,10,10,290,1,27,50,4,2,63,48,2,2000,1:1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"