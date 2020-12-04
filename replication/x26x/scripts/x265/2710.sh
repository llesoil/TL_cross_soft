#!/bin/sh

numb='2711'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 15 --keyint 230 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.6,1.0,2.0,0.5,0.7,0.0,2,2,12,15,230,3,26,40,4,0,65,38,3,2000,1:1,dia,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"