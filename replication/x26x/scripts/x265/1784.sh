#!/bin/sh

numb='1785'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 15 --keyint 230 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.2,1.0,5.0,0.3,0.6,0.0,1,2,6,15,230,2,25,50,5,3,63,48,5,1000,-2:-2,hex,show,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"