#!/bin/sh

numb='986'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 15 --keyint 250 --lookahead-threads 3 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.3,1.3,4.8,0.3,0.9,0.3,1,1,2,15,250,3,21,50,4,1,65,48,3,1000,-2:-2,hex,show,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"