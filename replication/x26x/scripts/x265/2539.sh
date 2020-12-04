#!/bin/sh

numb='2540'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 260 --lookahead-threads 4 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.2,1.3,3.2,0.5,0.9,0.6,2,0,16,40,260,4,23,30,4,3,65,48,4,1000,-1:-1,umh,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"