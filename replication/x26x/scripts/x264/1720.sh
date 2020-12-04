#!/bin/sh

numb='1721'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.4,1.0,1.6,0.3,0.8,0.5,2,0,6,45,230,0,23,50,4,3,61,28,3,2000,-1:-1,dia,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"